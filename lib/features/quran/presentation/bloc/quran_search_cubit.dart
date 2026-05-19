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
      final String response = await rootBundle.loadString('assets/quran_search.json');
      final List<dynamic> data = json.decode(response);
      _allVerses = data.cast<Map<String, dynamic>>();
      emit(QuranSearchLoaded(_allVerses, const []));
    } catch (e) {
      emit(QuranSearchError(e.toString()));
    }
  }

  String _removeDiacritics(String text) {
    return text.replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED\u06DF-\u06E8]'), '');
  }

  void search(String query) {
    if (_allVerses.isEmpty) return;
    
    if (query.trim().isEmpty) {
      emit(QuranSearchLoaded(_allVerses, const []));
      return;
    }

    String normalizedQuery = _removeDiacritics(query.trim());
    List<SearchResult> results = [];
    Set<int> foundSurahs = {};

    for (var verse in _allVerses) {
      final surahName = (verse['surahName'] ?? '').toString();
      final surahNumber = (verse['surahNumber'] as int?) ?? 0;
      final normalizedSurahName = _removeDiacritics(surahName);
      final page = (verse['page'] as int?);
      final verseNumber = (verse['verseNumber'] as int?);
      final text = (verse['text'] ?? '').toString();
      final normalizedText = (verse['normalized_text'] ?? '').toString();

      if (surahNumber == 0) continue;

      // Surah name match
      if (normalizedSurahName.contains(normalizedQuery) &&
          !foundSurahs.contains(surahNumber)) {
        results.add(SearchResult(
          isSurah: true,
          surahNumber: surahNumber,
          surahName: surahName,
          page: page,
        ));
        foundSurahs.add(surahNumber);
      }

      // Ayah text match
      if (normalizedText.isNotEmpty && normalizedText.contains(normalizedQuery)) {
        results.add(SearchResult(
          isSurah: false,
          surahNumber: surahNumber,
          surahName: surahName,
          verseNumber: verseNumber,
          page: page,
          text: text,
        ));
      }
      
      if (results.length > 100) break;
    }

    emit(QuranSearchLoaded(_allVerses, results));
  }
}
