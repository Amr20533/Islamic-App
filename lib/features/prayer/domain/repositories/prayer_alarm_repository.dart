abstract class PrayerAlarmRepository {
  Future<Map<String, bool>> getAlarmStates(List<String> keys);
  Future<void> saveAlarmState(String key, bool isEnabled);
}
