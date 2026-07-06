import 'dart:async';
import 'package:flutter/material.dart';
import 'package:islamic_app/core/models/auth/signup_model.dart';
import 'package:islamic_app/core/models/db/app_tables.dart';
import 'package:islamic_app/core/models/db/database_config.dart';
import 'package:islamic_app/core/models/db/table_schema.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._internal();

  static final DBHelper instance = DBHelper._internal();

  factory DBHelper() => instance;


  final Map<String, Database> _databases = {};


  Future<Database> database(DatabaseConfig dbConfig) async {
    if (_databases.containsKey(dbConfig.name)) {
      return _databases[dbConfig.name]!;
    }

    final db = await _initDatabase(dbConfig);

    _databases[dbConfig.name] = db;

    return db;
  }

  Future<Database> _initDatabase(DatabaseConfig dbConfig) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbConfig.name);

    return openDatabase(
      path,
      version: dbConfig.version,
      onCreate: (db, version) => _onCreate(db, version, dbConfig),
      onUpgrade: (db, oldVersion, newVersion) =>
          _onUpgrade(db, oldVersion, newVersion, dbConfig.tables),
      onOpen: _onOpen,
    );
  }

  Future<void> _onCreate(Database db,
      int version,
      DatabaseConfig config,) async {
    for (final table in config.tables) {
      await db.execute(table.createSql);
    }
  }

  Future<void> _onOpen(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');

    debugPrint('Database opened');
  }

  Future<void> _onUpgrade(Database db,
      int oldVersion,
      int newVersion,
      List<TableSchema> tables,) async {
  }

  /// ------------------> Create User <--------------------
  Future<int> insertUser(SignUpModel user) async {
    final db = await database(DatabaseConfig.signup);

    return db.insert(
      AppTables.users.name,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

}