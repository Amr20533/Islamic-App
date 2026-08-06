import 'package:islamic_app/core/models/auth/signup_model.dart';
import 'package:islamic_app/core/models/db/table_schema.dart';

class AppTables {
  static const users = TableSchema(
    name: 'users',
    createSql: '''
      CREATE TABLE IF NOT EXISTS users (
        ${SignUpModel.colId}            INTEGER PRIMARY KEY AUTOINCREMENT,
        ${SignUpModel.colFullName}      TEXT    NOT NULL,
        ${SignUpModel.colEmailAddress}  TEXT    UNIQUE NOT NULL,
        ${SignUpModel.colPassword}      TEXT    NOT NULL,
        created_at TEXT    DEFAULT (datetime('now'))
      )
    ''',
  );

  static const bookmarks = TableSchema(
    name: 'bookmarks',
    createSql: '''
      CREATE TABLE IF NOT EXISTS bookmarks (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id    INTEGER NOT NULL,
        url        TEXT    NOT NULL,
        title      TEXT,
        created_at TEXT    DEFAULT (datetime('now')),
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''',
  );

  static const tracker = TableSchema(
    name: 'tracker',
    createSql: '''
      CREATE TABLE IF NOT EXISTS tracker (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id    INTEGER NOT NULL,
        action     TEXT    NOT NULL,
        created_at TEXT    DEFAULT (datetime('now')),
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''',
  );

  /// Every table registered here gets created automatically.
  static const all = [users, bookmarks, tracker];
}