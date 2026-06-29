import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  DBHelper._internal();
  static final DBHelper instance = DBHelper._internal();
  factory DBHelper() => instance;


  static Database? _database;
  static const String _trackerDbName = 'daily_tracker_db.db';
  static const int _trackerDbVersion = 1;
  static const String _signupDbName = 'signup_db.db';
  static const int _signupDbVersion = 1;


  Future<Database> get database async{
    _database ??= await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _signupDbName);


    return openDatabase(
      path,
      version: _signupDbVersion,
      onCreate:  _onCreate,
      onUpgrade: _onUpgrade,
      onOpen:    _onOpen,
    );
  }

  Future<void> _onCreate(Database db)async{
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        name      TEXT    NOT NULL,
        email     TEXT    UNIQUE NOT NULL,
        age       INTEGER,
        created_at TEXT   DEFAULT (datetime('now'))
      )
    ''');
  }


  }