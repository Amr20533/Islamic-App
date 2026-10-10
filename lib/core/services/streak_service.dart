import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  final SharedPreferences _prefs;

  StreakService(this._prefs);

  static const _totalStreakKey = 'streak_total_days';
  static const _lastCompletedDateKey = 'streak_last_completed_date';

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

  /// Returns the total number of completed days ever (never resets).
  /// Call [tryIncrementStreak] after each task completion to keep it updated.
  int calculateStreak() {
    return _prefs.getInt(_totalStreakKey) ?? 0;
  }

  /// If today is newly completed (all 3 tasks done) and hasn't been counted yet,
  /// increments the total streak counter by 1 and saves today's date as last counted.
  /// Safe to call multiple times — only counts once per day.
  Future<void> tryIncrementStreak() async {
    final today = DateTime.now();
    final todayKey = _dateKey(today);
    final lastCounted = _prefs.getString(_lastCompletedDateKey) ?? '';

    // Only count if today is newly completed and hasn't been counted yet
    if (lastCounted == todayKey) return;
    if (!isDayCompleted(today)) return;

    final current = _prefs.getInt(_totalStreakKey) ?? 0;
    await _prefs.setInt(_totalStreakKey, current + 1);
    await _prefs.setString(_lastCompletedDateKey, todayKey);
  }
}
