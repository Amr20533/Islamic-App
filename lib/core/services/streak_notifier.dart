import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'streak_service.dart';

/// A ValueNotifier that holds the cumulative total of completed days.
/// Call [refreshAndIncrement] after any daily task completes to auto-update all listeners.
/// The count NEVER resets — it only grows each time the user completes all 3 tasks in a new day.
class StreakNotifier extends ValueNotifier<int> {
  final SharedPreferences _prefs;

  StreakNotifier(this._prefs) : super(0) {
    refresh();
  }

  /// Simply re-reads the stored total (no increment).
  void refresh() {
    value = StreakService(_prefs).calculateStreak();
  }

  /// Tries to increment the total if today is newly completed, then refreshes.
  Future<void> refreshAndIncrement() async {
    await StreakService(_prefs).tryIncrementStreak();
    refresh();
  }
}

