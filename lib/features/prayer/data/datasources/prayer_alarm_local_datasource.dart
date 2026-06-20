import 'package:shared_preferences/shared_preferences.dart';

abstract class PrayerAlarmLocalDataSource {
  Future<bool> getAlarmState(String key);
  Future<void> saveAlarmState(String key, bool isEnabled);
}

class PrayerAlarmLocalDataSourceImpl implements PrayerAlarmLocalDataSource {
  final SharedPreferences sharedPreferences;

  PrayerAlarmLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> getAlarmState(String key) async {
    return sharedPreferences.getBool(key) ?? false;
  }

  @override
  Future<void> saveAlarmState(String key, bool isEnabled) async {
    await sharedPreferences.setBool(key, isEnabled);
  }
}
