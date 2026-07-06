import 'package:islamic_app/core/models/auth/signup_model.dart';
import 'package:islamic_app/core/models/db/app_tables.dart';
import 'package:islamic_app/core/models/db/database_config.dart';
import 'package:islamic_app/core/services/helpers/db.helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  UserRepository({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  final SharedPreferences _prefs;


  Future<int> createUser(SignUpModel user) {
    return DBHelper.instance.insertUser(user);
  }


  Future<SignUpModel?> login(
      String email,
      String password,
      ) async {
    final db = await DBHelper.instance.database(
      DatabaseConfig.signup,
    );

    final result = await db.query(
      AppTables.users.name,
      where:
      '${SignUpModel.colEmailAddress} = ? AND ${SignUpModel.colPassword} = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return SignUpModel.fromJson(result.first);
  }

  Future<void> saveUserId(int id) async {
    await _prefs.setInt('user_id', id);
  }

  int? get userId => _prefs.getInt('user_id');

  bool get isLoggedIn => userId != null;

  Future<void> logout() async {
    await _prefs.remove('user_id');
  }

  Future<SignUpModel?> currentUser() async {
    final id = userId;

    if (id == null) return null;

    final db = await DBHelper.instance.database(
      DatabaseConfig.signup,
    );

    final result = await db.query(
      AppTables.users.name,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return SignUpModel.fromJson(result.first);
  }
}