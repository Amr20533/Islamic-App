import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'streak_service.dart';

/// A ValueNotifier that holds the current streak count.
/// Call [refresh] after any daily task completes to auto-update all listeners.
class StreakNotifier extends ValueNotifier<int> {
  final SharedPreferences _prefs;

  StreakNotifier(this._prefs) : super(0) {
    refresh();
  }

  void refresh() {
    value = StreakService(_prefs).calculateStreak();
  }
}
