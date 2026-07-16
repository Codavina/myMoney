import 'package:my_money/core/database/app_database.dart';
import 'package:my_money/core/models/transaction_model.dart';
import 'package:sqflite/sqflite.dart';

import '../errors/database_error_handler.dart';

class TransactionRepository {
  final _dbProvider = AppDatabase.instance;

  Future<int> insert(TransactionModel transaction) async {
    try {
      final db = await _dbProvider.database;

      return await db.insert('Transactions', transaction.toMap());
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  Future<List<TransactionModel>> getAll() async {
    try {
      final db = await _dbProvider.database;

      final result = await db.query('Transactions');

      return result.map((e) => TransactionModel.fromMap(e)).toList();
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  Future<TransactionModel?> getById(int id) async {
    try {
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
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  Future<int> update(TransactionModel transaction) async {
    try {
      final db = await _dbProvider.database;
      final result = await db.update(
        'Transactions',
        transaction.toMap(),
        where: 'transaction_id=?',
        whereArgs: [transaction.transactionId],
      );

      return result;
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  Future<int> delete(int id) async {
    try {
      final db = await _dbProvider.database;

      return await db.delete(
        'Transactions',
        where: 'transaction_id=?',
        whereArgs: [id],
      );
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  Future<List<TransactionModel>> getByFund(int fundId) async {
    try {
      final db = await _dbProvider.database;

      final result = await db.query(
        'Transactions',
        where: 'fund_id = ?',
        whereArgs: [fundId],
        orderBy: 'transaction_date DESC, transaction_id DESC',
      );

      return result.map(TransactionModel.fromMap).toList();
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }
}
