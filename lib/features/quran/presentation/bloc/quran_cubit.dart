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
  final Map<int, List<Verse>> pagesInCurrentSurah;
  final List<AudioReciter> reciters;

  const QuranLoaded(this.pagesInCurrentSurah, this.reciters);

  List<int> get sortedPageNumbers => pagesInCurrentSurah.keys.toList()..sort();

  @override
  List<Object?> get props => [pagesInCurrentSurah, reciters];
}

class QuranError extends QuranState {
  final String message;
  const QuranError(this.message);
  @override
  List<Object?> get props => [message];
}

class QuranCubit extends Cubit<QuranState> {
  QuranCubit() : super(QuranInitial());

  Future<void> loadSurahData(int surahNumber) async {
    emit(QuranLoading());
    try {
      final String response = await rootBundle.loadString(
        'assets/surah/surah_$surahNumber.json',
      );
      final data = json.decode(response);
      List versesData = data['verses'];

      Map<int, List<Verse>> tempPages = {};

      for (var v in versesData) {
        Verse verse = Verse.fromJson(v);
        if (!tempPages.containsKey(verse.page)) {
          tempPages[verse.page] = [];
        }
        tempPages[verse.page]!.add(verse);
      }

      List audioData = data['audio'] ?? [];
      List<AudioReciter> reciters = audioData.map((e) => AudioReciter.fromJson(e)).toList();

      emit(QuranLoaded(tempPages, reciters));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }
}
