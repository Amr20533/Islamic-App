import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

class ThemeState {
  final ThemeMode themeMode;
  final AppThemeMode appThemeMode;

  const ThemeState({
    required this.themeMode,
    required this.appThemeMode,
  });

  bool get isDarkMode => appThemeMode == AppThemeMode.dark;
}

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themePrefKey = 'user_theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_getInitialState(_prefs));

  static ThemeState _getInitialState(SharedPreferences prefs) {
    final savedMode = prefs.getString(_themePrefKey);
    if (savedMode == 'dark') {
      return const ThemeState(
        themeMode: ThemeMode.dark,
        appThemeMode: AppThemeMode.dark,
      );
    } else if (savedMode == 'light') {
      return const ThemeState(
        themeMode: ThemeMode.light,
        appThemeMode: AppThemeMode.light,
      );
    }
    return const ThemeState(
      themeMode: ThemeMode.system,
      appThemeMode: AppThemeMode.system,
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    ThemeMode targetThemeMode;
    String modeString;

    switch (mode) {
      case AppThemeMode.dark:
        targetThemeMode = ThemeMode.dark;
        modeString = 'dark';
        break;
      case AppThemeMode.light:
        targetThemeMode = ThemeMode.light;
        modeString = 'light';
        break;
      case AppThemeMode.system:
        targetThemeMode = ThemeMode.system;
        modeString = 'system';
        break;
    }

    await _prefs.setString(_themePrefKey, modeString);
    emit(ThemeState(
      themeMode: targetThemeMode,
      appThemeMode: mode,
    ));
  }
}
