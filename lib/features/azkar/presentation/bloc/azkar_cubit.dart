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

  Future<void> loadCategories() async {
    emit(AzkarLoading());
    try {
      final String response = await rootBundle.loadString('assets/azkar.json');
      final List<dynamic> data = json.decode(response);
      final categories = data.map((e) => AzkarCategory.fromJson(e)).toList();
      emit(AzkarCategoriesLoaded(categories));
    } catch (e) {
      emit(AzkarError(e.toString()));
    }
  }

  Future<void> loadZikrDetails(int id) async {
    emit(AzkarLoading());
    try {
      final String response = await rootBundle.loadString(
        'assets/azkar/azkar.json',
      );
      final List<dynamic> data = json.decode(response);
      final selected = data.firstWhere((element) => element['ID'] == id);
      final List<dynamic> zikrData = selected['ZIKR'][0].values.first;

      final zikrList = zikrData
          .map(
            (z) => ZikrItem(
              arabicText: z['ARABIC_TEXT'],
              repeat: z['REPEAT'],
              audio: z['AUDIO'],
              id: z['ID'],
              translatedText: z['TRANSLATED_TEXT'],
            ),
          )
          .toList();

      emit(AzkarDetailsLoaded(zikrList));
    } catch (e) {
      emit(AzkarError(e.toString()));
    }
  }
}
