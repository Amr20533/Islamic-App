import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  final SharedPreferences _prefs;

  StreakService(this._prefs);

  static String _dateKey(DateTime date) =>
      "${date.year}-${date.month}-${date.day}";

  /// Returns true if all 3 tasks (Quran, Dhikr, Dua) were completed on [date].
  bool isDayCompleted(DateTime date) {
    final key = _dateKey(date);
    final quran = _prefs.getBool("daily_quran_done_$key") ?? false;
    final dhikr = _prefs.getBool("daily_dhikr_done_$key") ?? false;
    final dua = _prefs.getBool("daily_dua_done_$key") ?? false;
    return quran && dhikr && dua;
  }

  /// Calculates the current streak (consecutive completed days).
  /// Counts backwards from today until a day is not fully completed.
  /// If today is not yet completed we still count from yesterday (streak in progress).
  int calculateStreak() {
    final today = DateTime.now();
    int streak = 0;

    // If today is completed, start counting from today; otherwise from yesterday
    final startFrom = isDayCompleted(today) ? 0 : 1;

    for (int i = startFrom; i <= 365; i++) {
      final day = today.subtract(Duration(days: i));
      if (isDayCompleted(day)) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }
}
