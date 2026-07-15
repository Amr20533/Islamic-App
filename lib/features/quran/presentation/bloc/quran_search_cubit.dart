import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Search Models
class SearchResult {
  final bool isSurah;
  final int surahNumber;
  final String surahName;
  final int? verseNumber;
  final int? page;
  final String? text;

  SearchResult({
    required this.isSurah,
    required this.surahNumber,
    required this.surahName,
    this.verseNumber,
    this.page,
    this.text,
  });
}

abstract class QuranSearchState extends Equatable {
  const QuranSearchState();
  @override
  List<Object?> get props => [];
}

class QuranSearchInitial extends QuranSearchState {}

class QuranSearchLoading extends QuranSearchState {}

class QuranSearchLoaded extends QuranSearchState {
  final List<Map<String, dynamic>> allVerses;
  final List<SearchResult> searchResults;

  const QuranSearchLoaded(this.allVerses, this.searchResults);

  @override
  List<Object?> get props => [allVerses, searchResults];
}

class QuranSearchError extends QuranSearchState {
  final String message;
  const QuranSearchError(this.message);
  @override
  List<Object?> get props => [message];
}

class QuranSearchCubit extends Cubit<QuranSearchState> {
  QuranSearchCubit() : super(QuranSearchInitial());

  List<Map<String, dynamic>> _allVerses = [];

  Future<void> loadSearchData() async {
    if (_allVerses.isNotEmpty) {
      emit(QuranSearchLoaded(_allVerses, const []));
      return;
    }
    emit(QuranSearchLoading());
    try {
      final String response = await rootBundle.loadString(
        'assets/quran_search.json',
      );
      final List<dynamic> data = json.decode(response);
      _allVerses = data.cast<Map<String, dynamic>>();
      emit(QuranSearchLoaded(_allVerses, const []));
    } catch (e) {
      emit(QuranSearchError(e.toString()));
    }
  }

  /// Normalize Arabic text by removing diacritics, Uthmani-specific marks,
  /// and mapping special characters to their plain equivalents.
  String _normalizeArabic(String text) {
    var result = text;

    // 1. Remove standard Arabic diacritics (tashkeel)
    result = result.replaceAll(
      RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED\u06DF-\u06E8]'),
      '',
    );

    // 2. Remove Quran-specific marks (small letters, sajda marks, etc.)
    result = result.replaceAll(
      RegExp(r'[\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED]'),
      '',
    );

    // 3. Remove zero-width and formatting characters
    result = result.replaceAll(
      RegExp(r'[\u200B-\u200F\u202A-\u202E\u2060-\u2069\uFEFF]'),
      '',
    );

    // 4. Map Uthmani-specific characters to plain Arabic
    result = result.replaceAll('\u0671', '\u0627'); // ٱ (alef wasla) → ا
    result = result.replaceAll('\u0654', ''); // hamza above
    result = result.replaceAll('\u0655', ''); // hamza below
    result = result.replaceAll('ۥ', ''); // small waw
    result = result.replaceAll('ۦ', ''); // small ya
    result = result.replaceAll('ـ', ''); // tatweel (kashida)

    // 5. Normalize alef variants
    result = result.replaceAll('أ', 'ا');
    result = result.replaceAll('إ', 'ا');
    result = result.replaceAll('آ', 'ا');
    result = result.replaceAll('ٰ', 'ا'); // superscript alef → ا
    result = result.replaceAll('ى', 'ي'); // alef maqsura → ya

    // 6. Normalize hamza variants
    result = result.replaceAll('ؤ', 'و');
    result = result.replaceAll('ئ', 'ي');

    // 7. Normalize taa marbuta
    result = result.replaceAll('ة', 'ه');

    // 8. Remove Quran smallscript / signs (like ۗ ۘ ۙ ۚ ۛ ۜ ۞ ۩)
    result = result.replaceAll(
      RegExp(r'[\u06D6-\u06DE\u06E9\u06FD\u06FE\u0600-\u0605]'),
      '',
    );

    // 9. Collapse multiple spaces
    result = result.replaceAll(RegExp(r'\s+'), ' ').trim();

    return result;
  }

  void search(String query) {
    if (_allVerses.isEmpty) return;

    if (query.trim().isEmpty) {
      emit(QuranSearchLoaded(_allVerses, const []));
      return;
    }

    String normalizedQuery = _normalizeArabic(query.trim());
    List<SearchResult> results = [];
    Set<int> foundSurahs = {};

    for (var verse in _allVerses) {
      final surahName = (verse['surahName'] ?? '').toString();
      final surahNumber = (verse['surahNumber'] as int?) ?? 0;
      final normalizedSurahName = _normalizeArabic(surahName);
      final page = (verse['page'] as int?);
      final verseNumber = (verse['verseNumber'] as int?);
      final text = (verse['text'] ?? '').toString();
      final normalizedText = _normalizeArabic(
        (verse['normalized_text'] ?? text).toString(),
      );

      if (surahNumber == 0) continue;

      // Surah name match
      if (normalizedSurahName.contains(normalizedQuery) &&
          !foundSurahs.contains(surahNumber)) {
        results.add(
          SearchResult(
            isSurah: true,
            surahNumber: surahNumber,
            surahName: surahName,
            page: page,
          ),
        );
        foundSurahs.add(surahNumber);
      }

      // Ayah text match
      if (normalizedText.isNotEmpty &&
          normalizedText.contains(normalizedQuery)) {
        results.add(
          SearchResult(
            isSurah: false,
            surahNumber: surahNumber,
            surahName: surahName,
            verseNumber: verseNumber,
            page: page,
            text: text,
          ),
        );
      }

      if (results.length > 100) break;
    }

    emit(QuranSearchLoaded(_allVerses, results));
  }
}
