import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:my_money/core/repositories/transaction_repository.dart';
import 'package:my_money/core/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'currency_repository.dart';
import 'fund_repository.dart';
import 'package:path_provider/path_provider.dart';

class SyncRepository {
  final UserRepository _userRepository;
  final CurrencyRepository _currencyRepository;
  final FundRepository _fundRepository;
  final TransactionRepository _transactionRepository;

  SyncRepository({
    required UserRepository userRepository,
    required CurrencyRepository currencyRepository,
    required FundRepository fundRepository,
    required TransactionRepository transactionRepository,
  })  : _userRepository = userRepository,
        _currencyRepository = currencyRepository,
        _fundRepository = fundRepository,
        _transactionRepository = transactionRepository;





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

  Future<void> uploadUserUpdateFile(
      File file,
      String authId,
      ) async {

    log('sync_repository => uploadUserUpdateFile beginning');
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
    log('sync_repository => hasUpdate beginning');
    try {
      await Supabase.instance.client.storage
          .from('updates')
          .download('$authId/update.json');
      log('sync_repository => hasUpdate return true');
      return true;
    } catch (_) {
      log('sync_repository => hasUpdate return false');
      return false;
    }
  }

  Future<File> downloadUserUpdateFile(String authId) async {
    log('sync_repository => downloadUserUpdateFile beginning');

    final bytes = await Supabase.instance.client.storage
        .from('updates')
        .download('$authId/update.json');

    log('bytes: $bytes');
    final directory = await getApplicationDocumentsDirectory();
    log('directory: $directory');
    final file = File('${directory.path}/update.json');
    log('file: $file');
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
    final user = UserModel.fromMap(
      json['user'] as Map<String, dynamic>,
    );

    await _userRepository.upsert(user);
  }

}