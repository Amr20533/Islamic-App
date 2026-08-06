import 'package:islamic_app/features/prayer/data/datasources/prayer_alarm_local_datasource.dart';
import 'package:islamic_app/features/prayer/domain/repositories/prayer_alarm_repository.dart';

class PrayerAlarmRepositoryImpl implements PrayerAlarmRepository {
  final PrayerAlarmLocalDataSource localDataSource;

  PrayerAlarmRepositoryImpl({required this.localDataSource});

  @override
  Future<Map<String, bool>> getAlarmStates(List<String> keys) async {
    final Map<String, bool> states = {};
    for (final key in keys) {
      states[key] = await localDataSource.getAlarmState(key);
    }
    return states;
  }

  @override
  Future<void> saveAlarmState(String key, bool isEnabled) async {
    await localDataSource.saveAlarmState(key, isEnabled);
  }
}
