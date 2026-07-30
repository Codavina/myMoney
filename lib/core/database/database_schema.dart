import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSchema {
  static Future<void> create(Database db) async {
    ///Create Tables
    await _createUsersTable(db);
    await _createCurrenciesTable(db);
    await _createFundsTable(db);
    await _createTransactionsTable(db);
    await _createAppStateTable(db);


    ///Create Indexes
    await _createIndexes(db);

    ///Create Triggers
    await _createTriggers(db);

    _insertDefaultCurrencies(db);

    debugPrint(
      '=========== create method called from DatabaseSchema class =============',
    );
  }

  // ===========================
  // Tables
  // ===========================
  static Future<void> _createAppStateTable(Database db) async {
    await db.execute('''
    CREATE TABLE AppState(
      id INTEGER PRIMARY KEY CHECK(id = 1),
      sync_mode INTEGER NOT NULL
        DEFAULT 0
        CHECK(sync_mode IN (0,1))
    );
  ''');

    await db.insert(
      'AppState',
      {
        'id': 1,
        'sync_mode': 0,
      },
    );

    debugPrint('=========== AppState Table created =============');
  }

  static Future<void> _createUsersTable(Database db) async {
    await db.execute('''
    CREATE TABLE Users(
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,

      auth_id TEXT NOT NULL UNIQUE,

      full_name TEXT NOT NULL,

      email TEXT NOT NULL UNIQUE,
      
      phone TEXT,

      role TEXT NOT NULL
        CHECK(role IN ('admin', 'viewer')),

      created_at TEXT NOT NULL
        DEFAULT CURRENT_TIMESTAMP
    );
  ''');

    debugPrint('=========== Users Table created =============');
  }

  static Future<void> _createCurrenciesTable(Database db) async {
    await db.execute('''
      CREATE TABLE Currencies(
        currency_id INTEGER PRIMARY KEY AUTOINCREMENT,
        currency_code TEXT NOT NULL UNIQUE
          CHECK(length(currency_code) BETWEEN 3 AND 10)
      );
    ''');

    debugPrint('=========== Currencies Table created =============');
  }

  static Future<void> _createFundsTable(Database db) async {
    await db.execute('''
      CREATE TABLE Funds(
        fund_id INTEGER PRIMARY KEY AUTOINCREMENT,
        
        owner_id INTEGER NOT NULL,

        title TEXT NOT NULL,

        balance REAL NOT NULL
          DEFAULT 0
          CHECK(balance >= 0),

        currency_id INTEGER NOT NULL,

        is_archived INTEGER NOT NULL
          DEFAULT 0
          CHECK(is_archived IN (0,1)),

        created_at TEXT NOT NULL
          DEFAULT CURRENT_TIMESTAMP,
          
        FOREIGN KEY(owner_id)
          REFERENCES Users(user_id)
          ON UPDATE CASCADE
          ON DELETE CASCADE,

        FOREIGN KEY(currency_id)
          REFERENCES Currencies(currency_id)
          ON UPDATE CASCADE
          ON DELETE RESTRICT,
          
          UNIQUE(owner_id, title)
      );
    ''');

    debugPrint('=========== Funds Table created =============');
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
    debugPrint('=========== Transactions Table created =============');
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

    debugPrint('=========== Indexes created =============');
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
    WHEN (
      SELECT sync_mode
      FROM AppState
      WHERE id = 1
    ) = 0
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

    debugPrint('=========== TRIGGER trg_InsertTransaction created =============');

    // ==========================================================
    // 2. Restore Fund Balance After Delete Transaction
    // ==========================================================
    await db.execute('''
    CREATE TRIGGER trg_DeleteTransaction
    AFTER DELETE ON Transactions
    WHEN (
      SELECT sync_mode
      FROM AppState
      WHERE id = 1
    ) = 0
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

    debugPrint('=========== TRIGGER trg_DeleteTransaction created =============');

    // ==========================================================
    // 3. Prevent Withdraw If Balance Is Insufficient
    // ==========================================================
    await db.execute('''
    CREATE TRIGGER trg_CheckBalanceBeforeInsert
    BEFORE INSERT ON Transactions
    WHEN (
      SELECT sync_mode
      FROM AppState
      WHERE id = 1
    ) = 0
    AND NEW.transaction_type = 1
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

    debugPrint('=========== TRIGGER trg_CheckBalanceBeforeInsert created =============');

    // ==========================================================
    // 4. Prevent Transactions On Archived Fund
    // ==========================================================
    await db.execute('''
    CREATE TRIGGER trg_PreventTransactionOnArchivedFund
    BEFORE INSERT ON Transactions
    FOR EACH ROW
    WHEN (
      SELECT sync_mode
      FROM AppState
      WHERE id = 1
    ) = 0
    AND EXISTS (
      SELECT 1
      FROM Funds
      WHERE fund_id = NEW.fund_id
      AND is_archived = 1
    )
    BEGIN
      SELECT RAISE(
        ABORT,
        'Cannot add transactions to an archived fund'
      );
    END;
  ''');

    debugPrint('=========== TRIGGER trg_PreventTransactionOnArchivedFund created =============');
  }


  static Future<void> _insertDefaultCurrencies(Database db) async {
    final batch = db.batch();

    batch.insert('Currencies', {
      'currency_code': 'USD',

    });

    batch.insert('Currencies', {
      'currency_code': 'EUR',

    });

    batch.insert('Currencies', {
      'currency_code': 'DZD',

    });

    batch.insert('Currencies', {
      'currency_code': 'TND',

    });

    await batch.commit(noResult: true);
  }
}
