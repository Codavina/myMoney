import 'package:my_money/core/database/app_database.dart';
import 'package:my_money/core/models/fund_model.dart';

class FundRepository {
  final _dbProvider = AppDatabase.instance;

  //Insert
  Future<int> insert(FundModel fund) async {
    final db = await _dbProvider.database;

    return db.insert('Funds', fund.toMap());
  }

  //Read all
  Future<List<FundModel>> getAll() async {
    final db = await _dbProvider.database;
    final result = await db.query('Funds');

    return result.map((e) => FundModel.fromMap(e)).toList();
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
      fund.toMap(),
      where: 'fund_id=?',
      whereArgs: [fund.fundId],
    );

    return result;
  }

  //delete
  Future<int> delete(int id) async {
    final db = await _dbProvider.database;

    return db.delete('Funds', where: 'fund_id=?', whereArgs: [id]);
  }


}
