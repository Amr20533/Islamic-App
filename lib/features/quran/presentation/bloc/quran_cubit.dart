import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/quran/data/models/verse.dart';
import 'package:islamic_app/features/quran/data/models/audio_reciter.dart';

abstract class QuranState extends Equatable {
  const QuranState();
  @override
  List<Object?> get props => [];
}

class QuranInitial extends QuranState {}

class QuranLoading extends QuranState {}

class QuranLoaded extends QuranState {
  final Map<int, List<Verse>> pages;
  final List<AudioReciter> reciters;
  final Set<int> loadedSurahs;
  final int activeSurahNumber;

  const QuranLoaded({
    required this.pages,
    required this.reciters,
    required this.loadedSurahs,
    required this.activeSurahNumber,
  });

  // For backward compatibility
  Map<int, List<Verse>> get pagesInCurrentSurah => pages;
  List<int> get sortedPageNumbers => pages.keys.toList()..sort();

  @override
  List<Object?> get props => [pages, reciters, loadedSurahs, activeSurahNumber];
}

class QuranError extends QuranState {
  final String message;
  const QuranError(this.message);
  @override
  List<Object?> get props => [message];
}

class QuranCubit extends Cubit<QuranState> {
  QuranCubit() : super(QuranInitial());

  // Cache variables
  final Map<int, List<Verse>> _cachedPages = {};
  final Set<int> _loadedSurahs = {};

  Future<void> loadSurahData(int surahNumber, {bool showGlobalLoading = true}) async {
    if (showGlobalLoading) {
      emit(QuranLoading());
    }
    try {
      final String response = await rootBundle.loadString(
        'assets/surah/surah_$surahNumber.json',
      );
      final data = json.decode(response);
      final List versesData = data['verses'] ?? [];
      final String surahNameAr = data['name']?['ar'] ?? '';
      final int surahNum = data['number'] ?? surahNumber;

      // To avoid duplicate verses from the same Surah, clear existing cache entries for it
      for (var page in _cachedPages.keys) {
        _cachedPages[page]!.removeWhere((v) => v.surahNumber == surahNum);
      }

      for (var v in versesData) {
        Verse verse = Verse.fromJson(v);
        verse.surahNameAr = surahNameAr;
        verse.surahNumber = surahNum;
        _cachedPages[verse.page] ??= [];
        _cachedPages[verse.page]!.add(verse);
      }

      // Sort verses on each page to maintain correct Quranic sequence
      for (var page in _cachedPages.keys) {
        _cachedPages[page]!.sort((a, b) {
          if (a.surahNumber != b.surahNumber) {
            return a.surahNumber!.compareTo(b.surahNumber!);
          }
          return a.number!.compareTo(b.number!);
        });
      }

      List audioData = data['audio'] ?? [];
      List<AudioReciter> reciters = audioData.map((e) => AudioReciter.fromJson(e)).toList();

      _loadedSurahs.add(surahNum);

      emit(QuranLoaded(
        pages: Map.from(_cachedPages),
        reciters: reciters,
        loadedSurahs: Set.from(_loadedSurahs),
        activeSurahNumber: surahNum,
      ));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  Future<void> loadSurahIfNeeded(int surahNumber) async {
    if (_loadedSurahs.contains(surahNumber)) {
      // Already loaded, just update the active Surah number and reciters list
      if (state is QuranLoaded) {
        final loadedState = state as QuranLoaded;
        if (loadedState.activeSurahNumber != surahNumber) {
          try {
            final String response = await rootBundle.loadString(
              'assets/surah/surah_$surahNumber.json',
            );
            final data = json.decode(response);
            List audioData = data['audio'] ?? [];
            List<AudioReciter> reciters = audioData.map((e) => AudioReciter.fromJson(e)).toList();
            
            emit(QuranLoaded(
              pages: Map.from(_cachedPages),
              reciters: reciters,
              loadedSurahs: Set.from(_loadedSurahs),
              activeSurahNumber: surahNumber,
            ));
          } catch (e) {
            // Keep existing state on error
          }
        }
      } else {
        emit(QuranLoaded(
          pages: Map.from(_cachedPages),
          reciters: const [],
          loadedSurahs: Set.from(_loadedSurahs),
          activeSurahNumber: surahNumber,
        ));
      }
      return;
    }
    // Load without global spinner for smooth swiping
    await loadSurahData(surahNumber, showGlobalLoading: false);
  }
}
