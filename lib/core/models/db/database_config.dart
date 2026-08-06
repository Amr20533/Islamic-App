import 'package:islamic_app/core/models/db/app_tables.dart';
import 'package:islamic_app/core/models/db/table_schema.dart';

class DatabaseConfig {
  final String name;
  final int version;
  final List<TableSchema> tables;

  const DatabaseConfig({
    required this.name,
    required this.version,
    required this.tables,
  });

  static const signup = DatabaseConfig(
    name: 'signup.db',
    version: 1,
    tables: AppTables.all,
  );

}