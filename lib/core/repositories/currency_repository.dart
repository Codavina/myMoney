import 'package:my_money/core/models/currency_model.dart';
import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../errors/app_exception.dart';
import '../errors/database_error_handler.dart';


class CurrencyRepository {
  //Access singleton database instance
  final _dbProvider = AppDatabase.instance;

  //CREATE (Insert new currency)
  Future<int> insert(CurrencyModel currency) async {
    try {
      // Convert object → map before saving to SQLite
      final db = await _dbProvider.database;

      return await db.insert('Currencies', currency.toMap());
    }on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  //READ (Get All Currencies)
  Future<List<CurrencyModel>> getAll() async {
    try {
      final db = await _dbProvider.database;

      // Query returns List<Map<String, dynamic>>
      final result = await db.query('Currencies');

      // Convert each Map → Note object
      return result.map((e) => CurrencyModel.fromMap(e)).toList();
    }on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  //FIND (Get Currency by ID)
  Future<CurrencyModel?> getById(int id) async {
    try {
      final db = await _dbProvider.database;

      final result = await db.query(
        'Currencies',
        where: 'currency_id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isEmpty) {
        return null;
      }

      return CurrencyModel.fromMap(result.first);
    }on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  //UPDATE (Modify existing currency)
  Future<int> update(CurrencyModel currency) async {
    try {
      final db = await _dbProvider.database;
      final result = await db.update(
        'Currencies',
        currency.toMap(), // New data
        where: 'currency_id=?', // WHERE clause → prevents updating all rows
        whereArgs: [
          currency.currencyId,
        ], // Prevent SQL injection by using arguments
      );

      return result;
    }on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  //DELETE (Remove currency by ID)
  Future<int> delete(int id) async {
    try {
      final db = await _dbProvider.database;

      return await db.delete(
        'Currencies',
        where: 'currency_id = ?',
        whereArgs: [id],
      );
    } on DatabaseException catch (e) {
      if (e.toString().contains('FOREIGN KEY')) {
        throw const AppException(
          'This currency is being used by one or more funds and cannot be deleted.',
        );
      }

      throw DatabaseErrorHandler.handle(e);
    }
  }
}
