import 'package:flutter/cupertino.dart';
import 'package:my_money/core/database/app_database.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:sqflite/sqflite.dart';

import '../errors/app_exception.dart';
import '../errors/database_error_handler.dart';

class FundRepository {
  final _dbProvider = AppDatabase.instance;

  //Insert
  Future<int> insert(FundModel fund) async {

    try {
      final db = await _dbProvider.database;

      return await db.insert('Funds', fund.toMap());
    }on DatabaseException catch (e) {
      debugPrint("Repository Catch");
      debugPrint(e.runtimeType.toString());
      throw DatabaseErrorHandler.handle(e);
    }
  }

  //Read all
  Future<List<FundModel>> getAll() async {
    try {
      final db = await _dbProvider.database;
      final result = await db.query('Funds');

      return result.map((e) => FundModel.fromMap(e)).toList();
    }on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  //Read All Active funds
  Future<List<FundModel>> getAllActive() async {
    try {
      final db = await _dbProvider.database;

      final result = await db.query(
        'Funds',
        where: 'is_archived = ?',
        whereArgs: [0],
        orderBy: 'created_at DESC',
      );

      return result.map(FundModel.fromMap).toList();
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  //Read ALl Archived funds
  Future<List<FundModel>> getAllArchived() async {
    try {
      final db = await _dbProvider.database;

      final result = await db.query(
        'Funds',
        where: 'is_archived = ?',
        whereArgs: [1],
        orderBy: 'created_at DESC',
      );

      return result.map(FundModel.fromMap).toList();
    } on DatabaseException catch (e) {
      throw DatabaseErrorHandler.handle(e);
    }
  }

  //Read by id
  Future<FundModel?> getById(int id) async {
    final db = await _dbProvider.database;

    final result = await db.query(
      'Funds',
      where: 'fund_id=?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return FundModel.fromMap(result.first);
  }

  //Update
  Future<int> update(FundModel fund) async {
    final db = await _dbProvider.database;

    final result = await db.update(
      'Funds',
      {
        'title': fund.title,
        'currency_id': fund.currencyId,
      },
      where: 'fund_id = ?',
      whereArgs: [fund.fundId],
    );

    return result;
  }

  //delete
  Future<int> delete(int id) async {
    try {
      final db = await _dbProvider.database;

      return await db.delete('Funds', where: 'fund_id=?', whereArgs: [id]);
    }on DatabaseException catch (e) {

      if (e.toString().contains('FOREIGN KEY constraint failed')) {
        throw const AppException(
          'This fund contains transactions and cannot be deleted.',
        );
      }

      throw DatabaseErrorHandler.handle(e);
    }
  }

  Future<void> archive(int fundId) async {
    final db = await _dbProvider.database;

    await db.update(
      'Funds',
      {
        'is_archived': 1,
      },
      where: 'fund_id = ?',
      whereArgs: [fundId],
    );
  }

  Future<void> unarchive(int fundId) async {
    final db = await _dbProvider.database;

    await db.update(
      'Funds',
      {
        'is_archived': 0,
      },
      where: 'fund_id = ?',
      whereArgs: [fundId],
    );
  }
}
