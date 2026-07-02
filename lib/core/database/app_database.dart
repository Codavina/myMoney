import 'dart:developer';
import 'package:my_money/core/database/database_schema.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  // Singleton instance → ensures only ONE database connection exists
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _db;

  // Private constructor → prevents creating multiple instances
  AppDatabase._internal();

  // Public getter for database instance
  // Opens database only once and reuses it (performance optimization)
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  // Create or open the database file
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_money.db');

    // [version : 1] Database version → used for migrations later
    // [onCreate] Called only the FIRST time database is created
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _configureDB,
      onUpgrade: _upgradeDB
    );
  }

  // Create tables when database is first created
  Future<void> _createDB(Database db, int version) async {
    await DatabaseSchema.create(db);
    log("On Create (database created) ==========================");
  }


  // Configure the database before it is opened.
// This is called every time the database is opened.
// Used here to enable foreign key constraints in SQLite.
  Future<void> _configureDB(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    log("On Configure (foreign_keys configured) ==========================");
  }

  // Handles database schema changes when upgrading to a newer version.
// Add migration logic here to preserve existing user data.
  Future<void> _upgradeDB(Database db,int oldVersion,int newVersion,) async {
    log("On Upgrade (empty upgrade) ==========================");
  }
}
