import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/azkar/data/models/azkar_category.dart';
import 'package:islamic_app/features/azkar/data/models/zikr_item.dart';

abstract class AzkarState extends Equatable {
  const AzkarState();
  @override
  List<Object?> get props => [];
}

class AzkarInitial extends AzkarState {}

class AzkarLoading extends AzkarState {}

class AzkarCategoriesLoaded extends AzkarState {
  final List<AzkarCategory> categories;
  const AzkarCategoriesLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}

class AzkarDetailsLoaded extends AzkarState {
  final List<ZikrItem> zikrList;
  const AzkarDetailsLoaded(this.zikrList);
  @override
  List<Object?> get props => [zikrList];
}

class AzkarError extends AzkarState {
  final String message;
  const AzkarError(this.message);
  @override
  List<Object?> get props => [message];
}

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit() : super(AzkarInitial());

  // Cache the raw JSON data so we don't reload it every time
  List<dynamic>? _cachedData;

  Future<List<dynamic>> _loadJsonData() async {
    if (_cachedData != null) return _cachedData!;
    final String response = await rootBundle.loadString(
      'assets/azkar/azkar.json',
    );
    _cachedData = json.decode(response);
    return _cachedData!;
  }

  Future<void> loadCategories() async {
    emit(AzkarLoading());
    try {
      final data = await _loadJsonData();
      // Build categories directly from the JSON so IDs always match
      final categories = data
          .map((e) => AzkarCategory(id: e['ID'], title: e['TITLE']))
          .toList();
      emit(AzkarCategoriesLoaded(categories));
    } catch (e) {
      emit(AzkarError(e.toString()));
    }
  }

  Future<void> loadZikrDetails(int id) async {
    emit(AzkarLoading());
    try {
      final data = await _loadJsonData();

      final selected = data.firstWhere(
        (element) => element['ID'] == id,
        orElse: () => null,
      );
      if (selected == null) {
        emit(const AzkarError('لم يتم العثور على هذا الذكر'));
        return;
      }
      final List<dynamic> zikrData = selected['ZIKR'][0].values.first;
      final zikrList = zikrData
          .map(
            (z) => ZikrItem(
              arabicText: z['ARABIC_TEXT'] ?? '',
              repeat: z['REPEAT'] ?? 1,
              audio: z['AUDIO'] ?? '',
              id: z['ID'] ?? 0,
              translatedText: z['TRANSLATED_TEXT'] ?? '',
            ),
          )
          .toList();
      emit(AzkarDetailsLoaded(zikrList));
    } catch (e) {
      emit(AzkarError(e.toString()));
    }
  }
}
