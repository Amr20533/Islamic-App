import 'package:shared_preferences/shared_preferences.dart';

abstract class CalendarLocalDataSource {
  Future<List<bool>> getFardStates(String dateKey);
  Future<List<bool>> getSunnahStates(String dateKey);
  Future<void> saveFardStates(String dateKey, List<bool> states);
  Future<void> saveSunnahStates(String dateKey, List<bool> states);
}

class CalendarLocalDataSourceImpl implements CalendarLocalDataSource {
  final SharedPreferences sharedPreferences;

  CalendarLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<bool>> getFardStates(String dateKey) async {
    final list = sharedPreferences.getStringList("fard_$dateKey");
    if (list != null && list.length == 5) {
      return list.map((e) => e == 'true').toList();
    }
    return List.generate(5, (_) => false);
  }

  @override
  Future<List<bool>> getSunnahStates(String dateKey) async {
    final list = sharedPreferences.getStringList("sunnah_$dateKey");
    if (list != null && list.length == 5) {
      return list.map((e) => e == 'true').toList();
    }
    return List.generate(5, (_) => false);
  }

  @override
  Future<void> saveFardStates(String dateKey, List<bool> states) async {
    final list = states.map((e) => e.toString()).toList();
    await sharedPreferences.setStringList("fard_$dateKey", list);
  }

  @override
  Future<void> saveSunnahStates(String dateKey, List<bool> states) async {
    final list = states.map((e) => e.toString()).toList();
    await sharedPreferences.setStringList("sunnah_$dateKey", list);
  }
}
