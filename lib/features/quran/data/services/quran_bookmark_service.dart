import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Model representing a bookmarked verse.
class QuranBookmark {
  final int surahNumber;
  final int verseNumber;
  final String surahName;
  final int pageNumber;
  final String verseText;

  QuranBookmark({
    required this.surahNumber,
    required this.verseNumber,
    required this.surahName,
    required this.pageNumber,
    required this.verseText,
  });

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        'surahName': surahName,
        'pageNumber': pageNumber,
        'verseText': verseText,
      };

  factory QuranBookmark.fromJson(Map<String, dynamic> json) => QuranBookmark(
        surahNumber: json['surahNumber'],
        verseNumber: json['verseNumber'],
        surahName: json['surahName'],
        pageNumber: json['pageNumber'],
        verseText: json['verseText'],
      );
}

/// Service to handle local storage and persistence of verse bookmarks.
class QuranBookmarkService {
  static const String _keyBookmarks = 'quran_bookmarks_list';

  /// Adds a bookmark. Returns true if added, false if already exists.
  static Future<bool> addBookmark(QuranBookmark bookmark, SharedPreferences prefs) async {
    final list = await getBookmarks(prefs);
    final exists = list.any((b) => b.surahNumber == bookmark.surahNumber && b.verseNumber == bookmark.verseNumber);
    if (exists) return false;

    list.add(bookmark);
    return _saveBookmarksList(list, prefs);
  }

  /// Removes a bookmark.
  static Future<bool> removeBookmark(int surahNumber, int verseNumber, SharedPreferences prefs) async {
    final list = await getBookmarks(prefs);
    list.removeWhere((b) => b.surahNumber == surahNumber && b.verseNumber == verseNumber);
    return _saveBookmarksList(list, prefs);
  }

  /// Checks if a verse is already bookmarked.
  static Future<bool> isBookmarked(int surahNumber, int verseNumber, SharedPreferences prefs) async {
    final list = await getBookmarks(prefs);
    return list.any((b) => b.surahNumber == surahNumber && b.verseNumber == verseNumber);
  }

  /// Retrieves all bookmarks.
  static Future<List<QuranBookmark>> getBookmarks(SharedPreferences prefs) async {
    final jsonStr = prefs.getString(_keyBookmarks);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List decoded = jsonDecode(jsonStr);
      return decoded.map((e) => QuranBookmark.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> _saveBookmarksList(List<QuranBookmark> list, SharedPreferences prefs) async {
    final jsonStr = jsonEncode(list.map((b) => b.toJson()).toList());
    return prefs.setString(_keyBookmarks, jsonStr);
  }
}
