import 'dart:developer';

import 'package:sqflite/sqflite.dart';

class DatabaseSchema {
  static Future<void> create(Database db) async {
    ///Create Tables
    await _createUsersTable(db);
    await _createCurrenciesTable(db);
    await _createFundsTable(db);
    await _createTransactionsTable(db);

    ///Create Indexes
    await _createIndexes(db);

    ///Create Triggers
    await _createTriggers(db);

    log(
      '=========== create method called from DatabaseSchema class =============',
    );
  }

  // ===========================
  // Tables
  // ===========================
  static Future<void> _createUsersTable(Database db) async {
    await db.execute('''
    CREATE TABLE Users(
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,

      auth_id TEXT NOT NULL UNIQUE,

      name TEXT NOT NULL,

      email TEXT NOT NULL UNIQUE,

      role TEXT NOT NULL
        CHECK(role IN ('admin', 'viewer')),

      created_at TEXT NOT NULL
        DEFAULT CURRENT_TIMESTAMP
    );
  ''');

    log('=========== Users Table created =============');
  }


  static Future<void> _createCurrenciesTable(Database db) async {
    await db.execute('''
      CREATE TABLE Currencies(
        currency_id INTEGER PRIMARY KEY AUTOINCREMENT,
        currency_code TEXT NOT NULL UNIQUE
          CHECK(length(currency_code) BETWEEN 3 AND 10)
      );
    ''');

    log('=========== Currencies Table created =============');
  }

  static Future<void> _createFundsTable(Database db) async {
    await db.execute('''
      CREATE TABLE Funds(
        fund_id INTEGER PRIMARY KEY AUTOINCREMENT,

        title TEXT NOT NULL UNIQUE,

        balance REAL NOT NULL
          DEFAULT 0
          CHECK(balance >= 0),

        currency_id INTEGER NOT NULL,

        is_archived INTEGER NOT NULL
          DEFAULT 0
          CHECK(is_archived IN (0,1)),

        created_at TEXT NOT NULL
          DEFAULT CURRENT_TIMESTAMP,

        FOREIGN KEY(currency_id)
          REFERENCES Currencies(currency_id)
          ON UPDATE CASCADE
          ON DELETE RESTRICT
      );
    ''');

    log('=========== Funds Table created =============');
  }

  static Future<void> _createTransactionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE Transactions(
        transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,

        fund_id INTEGER NOT NULL,

        amount REAL NOT NULL
          CHECK(amount > 0),

        transaction_type INTEGER NOT NULL
          CHECK(transaction_type IN (0,1)),

        transaction_date TEXT NOT NULL,

        description TEXT NOT NULL,

        created_at TEXT NOT NULL
          DEFAULT CURRENT_TIMESTAMP,

        FOREIGN KEY(fund_id)
          REFERENCES Funds(fund_id)
          ON UPDATE CASCADE
          ON DELETE RESTRICT
      );
    ''');
    log('=========== Transactions Table created =============');
  }

  // ===========================
  // Indexes
  // ===========================

  static Future<void> _createIndexes(Database db) async {
    await db.execute('''
      CREATE INDEX IX_Transactions_Fund
      ON Transactions(fund_id);
    ''');

    await db.execute('''
      CREATE INDEX IX_Transactions_Date
      ON Transactions(transaction_date);
    ''');

    log('=========== Indexes created =============');
  }

  // ===========================
  // Triggers
  // ===========================

  static Future<void> _createTriggers(Database db) async {


    // ==========================================================
    // 1. Update Fund Balance After Insert Transaction
    // ==========================================================
    await db.execute('''
    CREATE TRIGGER trg_InsertTransaction
    AFTER INSERT ON Transactions
    BEGIN
      UPDATE Funds
      SET balance = balance +
      CASE
        WHEN NEW.transaction_type = 0 THEN NEW.amount
        ELSE -NEW.amount
      END
      WHERE fund_id = NEW.fund_id;
    END;
  ''');
    log('=========== TRIGGER trg_InsertTransaction created =============');
    // ==========================================================
    // 2. Restore Fund Balance After Delete Transaction
    // ==========================================================
    await db.execute('''
    CREATE TRIGGER trg_DeleteTransaction
    AFTER DELETE ON Transactions
    BEGIN
      UPDATE Funds
      SET balance = balance +
      CASE
        WHEN OLD.transaction_type = 0 THEN -OLD.amount
        ELSE OLD.amount
      END
      WHERE fund_id = OLD.fund_id;
    END;
  ''');
    log('=========== TRIGGER trg_DeleteTransaction created =============');
    // ==========================================================
    // 3. Prevent Withdraw If Balance Is Insufficient
    // ==========================================================
    await db.execute('''
    CREATE TRIGGER trg_CheckBalanceBeforeInsert
    BEFORE INSERT ON Transactions
    WHEN NEW.transaction_type = 1
    BEGIN
      SELECT CASE
        WHEN (
          SELECT balance
          FROM Funds
          WHERE fund_id = NEW.fund_id
        ) < NEW.amount
        THEN RAISE(ABORT, 'Insufficient balance')
      END;
    END;
  ''');
    log(
      '=========== TRIGGER trg_CheckBalanceBeforeInsert created =============',
    );
    // ==========================================================
    // 4. Prevent transactions on archived fund
    // ==========================================================
    await db.execute('''CREATE TRIGGER trg_PreventTransactionOnArchivedFund
BEFORE INSERT ON Transactions
FOR EACH ROW
WHEN EXISTS (
    SELECT 1
    FROM Funds
    WHERE fund_id = NEW.fund_id
      AND is_archived = 1
)
BEGIN
    SELECT RAISE(ABORT,
        'Cannot add transactions to an archived fund');
END;''');
    log(
      '=========== TRIGGER trg_PreventTransactionOnArchivedFund created =============',
    );
  }
}
