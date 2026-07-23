import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../errors/database_error_handler.dart';
import '../models/user_model.dart';

class UserRepository {
  final _dbProvider = AppDatabase.instance;

  /// Insert
  Future<int> insert(UserModel user) async {
    try {
      final db = await _dbProvider.database;

      return await db.insert(
        'Users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  /// Get All
  Future<List<UserModel>> getAll() async {
    try {
      final db = await _dbProvider.database;

      final result = await db.query(
        'Users',
        orderBy: 'full_name',
      );

      return result.map(UserModel.fromMap).toList();
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  /// Get By SQLite Id
  Future<UserModel?> getById(int id) async {
    try {
      final db = await _dbProvider.database;

      final result = await db.query(
        'Users',
        where: 'user_id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isEmpty) return null;

      return UserModel.fromMap(result.first);
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  /// Get By Auth Id (UUID)
  Future<UserModel?> getByAuthId(String authId) async {
    try {
      final db = await _dbProvider.database;

      final result = await db.query(
        'Users',
        where: 'auth_id = ?',
        whereArgs: [authId],
        limit: 1,
      );

      if (result.isEmpty) return null;

      return UserModel.fromMap(result.first);
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  /// Update
  Future<int> update(UserModel user) async {
    try {
      final db = await _dbProvider.database;

      return await db.update(
        'Users',
        user.toMap(),
        where: 'user_id = ?',
        whereArgs: [user.userId],
      );
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  /// Delete
  Future<int> delete(int id) async {
    try {
      final db = await _dbProvider.database;

      return await db.delete(
        'Users',
        where: 'user_id = ?',
        whereArgs: [id],
      );
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }
}