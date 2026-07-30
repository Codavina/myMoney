import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
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
    database,
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

    final transactions = await _transactionRepository.getAllByOwner(ownerId);

    final data = {
      'user': user.toMap(),
      'currencies': currencies.map((e) => e.toMap()).toList(),
      'funds': funds.map((e) => e.toMap()).toList(),
      'transactions': transactions.map((e) => e.toMap()).toList(),
    };

    final jsonString = jsonEncode(data);

    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/update.json');

    await file.writeAsString(jsonString);

    return file;
  }

  Future<void> uploadUserUpdateFile(File file, String authId) async {
    debugPrint('sync_repository => uploadUserUpdateFile beginning');
    await Supabase.instance.client.storage
        .from('updates')
        .upload(
          '$authId/update.json',
          file,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'application/json',
          ),
        );
  }
  Future<bool> hasUpdate(String authId) async {
    debugPrint('sync_repository => hasUpdate beginning');

    try {
      final files = await Supabase.instance.client.storage
          .from('updates')
          .list(path: authId);

      final exists = files.any(
            (file) => file.name == 'update.json',
      );

      debugPrint('sync_repository => hasUpdate return $exists');

      return exists;
    } catch (e) {
      debugPrint('sync_repository => hasUpdate ERROR: $e');
      return false;
    }
  }
  // Future<bool> hasUpdate(String authId) async {
  //   debugPrint('sync_repository => hasUpdate beginning');
  //   try {
  //     await Supabase.instance.client.storage
  //         .from('updates')
  //         .download('$authId/update.json');
  //     debugPrint('sync_repository => hasUpdate return true');
  //     return true;
  //   } catch (_) {
  //     debugPrint('sync_repository => hasUpdate return false');
  //     return false;
  //   }
  // }

  Future<File> downloadUserUpdateFile(String authId) async {
    debugPrint('sync_repository => downloadUserUpdateFile beginning');

    final bytes = await Supabase.instance.client.storage
        .from('updates')
        .download('$authId/update.json');

    final directory = await getApplicationDocumentsDirectory();
    debugPrint('directory: $directory');
    final file = File('${directory.path}/update.json');
    debugPrint('file: $file');
    await file.writeAsBytes(bytes);

    return file;
  }

  Future<Map<String, dynamic>> readUpdateFile() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/update.json');

    final json = await file.readAsString();

    return jsonDecode(json) as Map<String, dynamic>;
  }

  Future<void> importUser(Map<String, dynamic> json) async {
    debugPrint('========== IMPORT START ==========');

    final db = await _database.database;

    await db.transaction((txn) async {
      // ------------------------------------------------------
      // Enable Sync Mode (Disable Triggers)
      // ------------------------------------------------------
      await txn.update(
        'AppState',
        {'sync_mode': 1},
        where: 'id = ?',
        whereArgs: [1],
      );

      debugPrint('===== Sync Mode ENABLED =====');

      try {
        // =====================================================
        // 1. Import User
        // =====================================================

        final userMap = json['user'] as Map<String, dynamic>;

        debugPrint('Importing userId = ${userMap['user_id']}');

        final userId = userMap['user_id'];

        final existingUser = await txn.query(
          'Users',
          where: 'user_id = ?',
          whereArgs: [userId],
        );

        if (existingUser.isEmpty) {
          debugPrint('Inserting user...');

          await txn.insert('Users', userMap);
        } else {
          debugPrint('Updating user...');

          final rows = await txn.update(
            'Users',
            userMap,
            where: 'user_id = ?',
            whereArgs: [userId],
          );

          debugPrint('User updated rows = $rows');
        }

        // =====================================================
        // 2. Import Currencies
        // =====================================================

        final currencies = json['currencies'] as List<dynamic>;

        debugPrint('Currencies count = ${currencies.length}');

        for (final currency in currencies) {
          final map = currency as Map<String, dynamic>;

          final currencyId = map['currency_id'];

          final existing = await txn.query(
            'Currencies',
            where: 'currency_id = ?',
            whereArgs: [currencyId],
          );

          if (existing.isEmpty) {
            debugPrint(
              'INSERT Currency id=$currencyId '
              'code=${map['currency_code']}',
            );

            await txn.insert('Currencies', map);
          } else {
            debugPrint(
              'UPDATE Currency id=$currencyId '
              'code=${map['currency_code']}',
            );

            await txn.update(
              'Currencies',
              {'currency_code': map['currency_code']},
              where: 'currency_id = ?',
              whereArgs: [currencyId],
            );
          }
        }
        // =====================================================
        // 3. Import Funds
        // =====================================================

        final funds = json['funds'] as List<dynamic>;

        debugPrint('Funds count = ${funds.length}');

        for (final fund in funds) {
          final map = fund as Map<String, dynamic>;

          final fundId = map['fund_id'];

          final existing = await txn.query(
            'Funds',
            where: 'fund_id = ?',
            whereArgs: [fundId],
          );

          if (existing.isEmpty) {
            debugPrint(
              'INSERT Fund id=$fundId '
              'balance=${map['balance']}',
            );

            await txn.insert('Funds', map);
          } else {
            debugPrint(
              'UPDATE Fund id=$fundId '
              'balance=${map['balance']}',
            );

            await txn.update(
              'Funds',
              map,
              where: 'fund_id = ?',
              whereArgs: [fundId],
            );
          }
        }

        // =====================================================
        // 4. Import Transactions
        // =====================================================

        final transactions = (json['transactions'] as List<dynamic>)
            .cast<Map<String, dynamic>>();

        transactions.sort(
          (a, b) => (a['transaction_id'] as int).compareTo(
            b['transaction_id'] as int,
          ),
        );

        debugPrint('Transactions count = ${transactions.length}');

        for (final map in transactions) {
          final transactionId = map['transaction_id'];

          final existing = await txn.query(
            'Transactions',
            where: 'transaction_id = ?',
            whereArgs: [transactionId],
          );

          if (existing.isEmpty) {
            debugPrint('INSERT Transaction id=$transactionId');

            await txn.insert('Transactions', map);
          } else {
            debugPrint('SKIP Transaction id=$transactionId');
          }
        }

        debugPrint('========== IMPORT FINISHED ==========');
      } finally {
        // ------------------------------------------------------
        // Disable Sync Mode
        // ------------------------------------------------------
        await txn.update(
          'AppState',
          {'sync_mode': 0},
          where: 'id = ?',
          whereArgs: [1],
        );

        debugPrint('===== Sync Mode DISABLED =====');
      }
    });

    debugPrint('===== IMPORT COMPLETED =====');
  }

  Future<void> deleteLocalUpdateFile() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/update.json');

    if (await file.exists()) {
      await file.delete();

      debugPrint('===== Local update.json deleted =====');
    } else {
      debugPrint('===== No local update.json found =====');
    }
  }

  Future<void> deleteRemoteUpdateFile(String authId) async {
    debugPrint('Deleting remote update file...');
    await Supabase.instance.client.storage.from('updates').remove([
      '$authId/update.json',
    ]);

    debugPrint('===== Remote update.json deleted =====');
  }
}
