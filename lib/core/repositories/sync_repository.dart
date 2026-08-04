import 'dart:io';
import 'dart:convert';
import 'package:my_money/core/repositories/transaction_repository.dart';
import 'package:my_money/core/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/app_database.dart';
import 'currency_repository.dart';
import 'fund_repository.dart';
import 'package:path_provider/path_provider.dart';

class SyncRepository {
  final UserRepository _userRepository;
  final CurrencyRepository _currencyRepository;
  final FundRepository _fundRepository;
  final TransactionRepository _transactionRepository;
  final AppDatabase _database;

  SyncRepository({
    required UserRepository userRepository,
    required CurrencyRepository currencyRepository,
    required FundRepository fundRepository,
    required TransactionRepository transactionRepository,
    required AppDatabase database,
  }) : _userRepository = userRepository,
       _currencyRepository = currencyRepository,
       _fundRepository = fundRepository,
       _transactionRepository = transactionRepository,
       _database = database;

  Future<File> createUserUpdateFile(int ownerId) async {
    final user = await _userRepository.getById(ownerId);

    if (user == null) {
      throw Exception('User not found.');
    }

    final currencies = await _currencyRepository.getAll();

    final funds = await _fundRepository.getAll(ownerId);

    final transactions =
    await _transactionRepository.getAllByOwner(ownerId);

    final data = {
      'user': user.toMap(),
      'currencies': currencies
          .map((currency) => currency.toMap())
          .toList(),
      'funds': funds
          .map((fund) => fund.toMap())
          .toList(),
      'transactions': transactions
          .map((transaction) => transaction.toMap())
          .toList(),
    };

    final jsonString = jsonEncode(data);

    final directory = await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/update.json',
    );

    await file.writeAsString(
      jsonString,
      flush: true,
    );

    return file;
  }

  Future<void> uploadUserUpdateFile(
      File file,
      String authId,
      ) async {
    final path = '$authId/update.json';

    await Supabase.instance.client.storage
        .from('updates')
        .upload(
      path,
      file,
      fileOptions: const FileOptions(
        upsert: true,
        contentType: 'application/json',
      ),
    );
  }

  Future<bool> hasUpdate(String authId) async {
    try {
      final files = await Supabase.instance.client.storage
          .from('updates')
          .list(path: authId);

      return files.any(
            (file) => file.name == 'update.json',
      );
    } catch (_) {
      return false;
    }
  }

  Future<File> downloadUserUpdateFile(String authId) async {
    final remotePath = '$authId/update.json';

    final bytes = await Supabase.instance.client.storage
        .from('updates')
        .download(remotePath);

    final directory =
    await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/update.json',
    );

    await file.writeAsBytes(
      bytes,
      flush: true,
    );

    return file;
  }

  Future<Map<String, dynamic>> readUpdateFile() async {
    final directory =
    await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/update.json',
    );

    final jsonString = await file.readAsString();

    final json =
    jsonDecode(jsonString) as Map<String, dynamic>;

    return json;
  }

  Future<void> importUser(Map<String, dynamic> json) async {
    final db = await _database.database;

    await db.transaction((txn) async {
      // =========================================================
      // Enable Sync Mode
      // =========================================================

      await txn.update(
        'AppState',
        {'sync_mode': 1},
        where: 'id = ?',
        whereArgs: [1],
      );

      try {
        // =======================================================
        // 1. Read JSON
        // =======================================================

        final userMap = Map<String, dynamic>.from(
          json['user'] as Map<String, dynamic>,
        );

        final currencies = (json['currencies'] as List<dynamic>)
            .map(
              (e) => Map<String, dynamic>.from(
            e as Map<String, dynamic>,
          ),
        )
            .toList();

        final funds = (json['funds'] as List<dynamic>)
            .map(
              (e) => Map<String, dynamic>.from(
            e as Map<String, dynamic>,
          ),
        )
            .toList();

        final transactions = (json['transactions'] as List<dynamic>)
            .map(
              (e) => Map<String, dynamic>.from(
            e as Map<String, dynamic>,
          ),
        )
            .toList();

        // =======================================================
        // 2. Identify Local User
        // =======================================================

        final authId = userMap['auth_id'] as String;

        final existingUser = await txn.query(
          'Users',
          where: 'auth_id = ?',
          whereArgs: [authId],
          limit: 1,
        );

        int localUserId;

        if (existingUser.isEmpty) {
          // -----------------------------------------------------
          // User does not exist locally.
          // -----------------------------------------------------

          await txn.insert(
            'Users',
            userMap,
          );

          localUserId = userMap['user_id'] as int;
        } else {
          // -----------------------------------------------------
          // User already exists locally.
          // Keep the local user_id.
          // -----------------------------------------------------

          localUserId =
          existingUser.first['user_id'] as int;

          await txn.update(
            'Users',
            {
              'auth_id': userMap['auth_id'],
              'full_name': userMap['full_name'],
              'email': userMap['email'],
              'phone': userMap['phone'],
              'role': userMap['role'],
            },
            where: 'user_id = ?',
            whereArgs: [localUserId],
          );
        }

        // =======================================================
        // 3. Read Current Local Funds
        // =======================================================

        final oldFunds = await txn.query(
          'Funds',
          columns: ['fund_id'],
          where: 'owner_id = ?',
          whereArgs: [localUserId],
        );

        // =======================================================
        // 4. Delete Old Transactions
        // =======================================================

        for (final row in oldFunds) {
          final fundId = row['fund_id'] as int;

          await txn.delete(
            'Transactions',
            where: 'fund_id = ?',
            whereArgs: [fundId],
          );
        }

        // =======================================================
        // 5. Delete Old Funds
        // =======================================================

        await txn.delete(
          'Funds',
          where: 'owner_id = ?',
          whereArgs: [localUserId],
        );

        // =======================================================
        // 6. Synchronize Currencies
        // =======================================================

        for (final map in currencies) {
          final currencyId = map['currency_id'] as int;

          final existing = await txn.query(
            'Currencies',
            where: 'currency_id = ?',
            whereArgs: [currencyId],
            limit: 1,
          );

          if (existing.isEmpty) {
            await txn.insert(
              'Currencies',
              map,
            );
          } else {
            await txn.update(
              'Currencies',
              {
                'currency_code': map['currency_code'],
              },
              where: 'currency_id = ?',
              whereArgs: [currencyId],
            );
          }
        }

        // =======================================================
        // 7. Insert Funds
        // =======================================================

        for (final map in funds) {
          // Admin user_id may differ from Viewer user_id.
          map['owner_id'] = localUserId;

          await txn.insert(
            'Funds',
            map,
          );
        }

        // =======================================================
        // 8. Insert Transactions As History
        // =======================================================

        transactions.sort(
              (a, b) {
            final aId =
            a['transaction_id'] as int;

            final bId =
            b['transaction_id'] as int;

            return aId.compareTo(bId);
          },
        );

        for (final map in transactions) {
          await txn.insert(
            'Transactions',
            map,
          );
        }
      } finally {
        // =======================================================
        // Disable Sync Mode
        // =======================================================

        await txn.update(
          'AppState',
          {'sync_mode': 0},
          where: 'id = ?',
          whereArgs: [1],
        );
      }
    });
  }

  Future<void> deleteLocalUpdateFile() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/update.json');

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> deleteRemoteUpdateFile(String authId) async {

    await Supabase.instance.client.storage.from('updates').remove([
      '$authId/update.json',
    ]);

  }
}
