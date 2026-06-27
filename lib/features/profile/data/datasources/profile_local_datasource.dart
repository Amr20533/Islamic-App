import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalDataSource {
  Future<bool> getDailyReminderEnabled();
  Future<void> saveDailyReminderEnabled(bool enabled);
  Future<String> getDailyReminderTime();
  Future<void> saveDailyReminderTime(String time);
  Future<String?> getProfileImagePath();
  Future<void> saveProfileImagePath(String? path);
  Future<String> getProfileName();
  Future<void> saveProfileName(String name);
  Future<String> getProfileEmail();
  Future<void> saveProfileEmail(String email);
  Future<String> getProfilePassword();
  Future<void> saveProfilePassword(String password);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const _keyDailyReminderEnabled = 'daily_reminder_enabled';
  static const _keyDailyReminderTime = 'daily_reminder_time';
  static const _keyProfileImagePath = 'profile_image_path';
  static const _keyProfileName = 'profile_name';
  static const _keyProfileEmail = 'profile_email';
  static const _keyProfilePassword = 'profile_password';

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> getDailyReminderEnabled() async {
    return sharedPreferences.getBool(_keyDailyReminderEnabled) ?? false;
  }

  @override
  Future<void> saveDailyReminderEnabled(bool enabled) async {
    await sharedPreferences.setBool(_keyDailyReminderEnabled, enabled);
  }

  @override
  Future<String> getDailyReminderTime() async {
    return sharedPreferences.getString(_keyDailyReminderTime) ?? '08:00 AM';
  }

  @override
  Future<void> saveDailyReminderTime(String time) async {
    await sharedPreferences.setString(_keyDailyReminderTime, time);
  }

  @override
  Future<String?> getProfileImagePath() async {
    return sharedPreferences.getString(_keyProfileImagePath);
  }

  @override
  Future<void> saveProfileImagePath(String? path) async {
    if (path == null) {
      await sharedPreferences.remove(_keyProfileImagePath);
    } else {
      await sharedPreferences.setString(_keyProfileImagePath, path);
    }
  }

  @override
  Future<String> getProfileName() async {
    return sharedPreferences.getString(_keyProfileName) ?? '';
  }

  @override
  Future<void> saveProfileName(String name) async {
    await sharedPreferences.setString(_keyProfileName, name);
  }

  @override
  Future<String> getProfileEmail() async {
    return sharedPreferences.getString(_keyProfileEmail) ?? 'user@gmail.com';
  }

  @override
  Future<void> saveProfileEmail(String email) async {
    await sharedPreferences.setString(_keyProfileEmail, email);
  }

  @override
  Future<String> getProfilePassword() async {
    return sharedPreferences.getString(_keyProfilePassword) ?? 'password';
  }

  @override
  Future<void> saveProfilePassword(String password) async {
    await sharedPreferences.setString(_keyProfilePassword, password);
  }
}
