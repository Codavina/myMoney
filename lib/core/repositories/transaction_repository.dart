import 'package:my_money/core/database/app_database.dart';
import 'package:my_money/core/models/transaction_model.dart';

class TransactionRepository {
  final _dbProvider = AppDatabase.instance;

  Future<int> insert(TransactionModel transaction) async {
    final db = await _dbProvider.database;

    return db.insert('Transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getAll() async {
    final db = await _dbProvider.database;

    final result = await db.query('Transactions');

    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<TransactionModel?> getById(int id) async {
    final db = await _dbProvider.database;

    final result = await db.query(
      'Transactions',
      where: 'transaction_id=?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }
    return TransactionModel.fromMap(result.first);
  }

  Future<int> update(TransactionModel transaction) async {
    final db = await _dbProvider.database;
    final result = await db.update(
      'Transactions',
      transaction.toMap(),
      where: 'transaction_id=?',
      whereArgs: [transaction.transactionId],
    );

    return result;
  }

  Future<int> delete(int id) async {
    final db = await _dbProvider.database;

    return db.delete(
      'Transactions',
      where: 'transaction_id=?',
      whereArgs: [id],
    );
  }

  Future<List<TransactionModel>> getByFund(int fundId) async {
    final db = await _dbProvider.database;

    final result = await db.query(
      'Transactions',
      where: 'fund_id = ?',
      whereArgs: [fundId],
      orderBy: 'transaction_date DESC, transaction_id DESC',
    );

    return result.map(TransactionModel.fromMap).toList();
  }

}
