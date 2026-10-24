import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranLastReadHelper {
  static final ValueNotifier<({String surahName, int pageNumber, int verseNumber})?> 
      lastReadNotifier = ValueNotifier(null);

  static const String _keySurahName = 'last_read_surah_name';
  static const String _keyPageNumber = 'last_read_page_number';
  static const String _keyVerseNumber = 'last_read_verse_number';

  /// Updates both the ValueNotifier and SharedPreferences
  static Future<void> update(String surahName, int pageNumber, int verseNumber) async {
    lastReadNotifier.value = (
      surahName: surahName,
      pageNumber: pageNumber,
      verseNumber: verseNumber,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySurahName, surahName);
    await prefs.setInt(_keyPageNumber, pageNumber);
    await prefs.setInt(_keyVerseNumber, verseNumber);
  }

  /// Save last read position to storage & update notifier (named parameter helper)
  static Future<void> saveLastRead({
    required String surahName,
    required int pageNumber,
    int verseNumber = 1,
  }) async {
    await update(surahName, pageNumber, verseNumber);
  }

  /// Initialize and load stored last read state at app start
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final surahName = prefs.getString(_keySurahName);
    final pageNumber = prefs.getInt(_keyPageNumber);
    final verseNumber = prefs.getInt(_keyVerseNumber) ?? 1;

    if (surahName != null && pageNumber != null) {
      lastReadNotifier.value = (
        surahName: surahName,
        pageNumber: pageNumber,
        verseNumber: verseNumber,
      );
    }
  }
}