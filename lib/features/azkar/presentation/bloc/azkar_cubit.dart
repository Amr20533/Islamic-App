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

  Future<void> loadZikrDetails(int id, [String? categoryTitle]) async {
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
      List<ZikrItem> zikrList = zikrData
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

      if (id == 27 && categoryTitle != null) {
        if (categoryTitle == 'أذكار الصباح') {
          // Exclude evening-only dhikr (ID 97: أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ...)
          zikrList = zikrList.where((item) => item.id != 97).toList();
        } else if (categoryTitle == 'أذكار المساء') {
          // Exclude morning-only dhikrs (ID 93, 94, 95)
          zikrList = zikrList
              .where((item) => item.id != 93 && item.id != 94 && item.id != 95)
              .toList();

          // Map morning phrases to evening phrases
          zikrList = zikrList.map((item) {
            String updatedText = item.arabicText;

            // Item 77: أصبحنا وأصبح الملك لله -> أمسينا وأمسى الملك لله
            if (item.id == 77) {
              updatedText = updatedText
                  .replaceAll('أَصْبَحْنَا', 'أَمْسَيْنَا')
                  .replaceAll('أَصْبَحَ', 'أَمْسَى')
                  .replaceAll('هَذَا الْيَوْمِ', 'هَذِهِ اللَّيْلَةِ')
                  .replaceAll('مَا بَعْدَهُ', 'مَا بَعْدَهَا');
            }
            // Item 78: اللهم بك أصبحنا... -> اللهم بك أمسينا...
            else if (item.id == 78) {
              updatedText = updatedText.replaceAll(
                'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا ، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
                'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ',
              );
            }
            // Item 79: أصبحت -> أمسيت
            else if (item.id == 79) {
              updatedText = updatedText.replaceAll('أَصْبَحْتُ', 'أَمْسَيْتُ');
            }
            // Item 80: أصبحت -> أمسيت
            else if (item.id == 80) {
              updatedText = updatedText.replaceAll('أَصْبَحْتُ', 'أَمْسَيْتُ');
            }
            // Item 81: ما أصبح -> ما أمسى
            else if (item.id == 81) {
              updatedText = updatedText.replaceAll(
                'مَا أَصْبَحَ',
                'مَا أَمْسَى',
              );
            }
            // Item 89: أصبحنا وأصبح... اليوم -> أمسينا وأمسى... الليلة
            else if (item.id == 89) {
              updatedText = updatedText
                  .replaceAll('أَصْبَحْنَا', 'أَمْسَيْنَا')
                  .replaceAll('أَصْبَحَ', 'أَمْسَى')
                  .replaceAll('هَذَا الْيَوْمِ', 'هَذِهِ اللَّيْلَةِ')
                  .replaceAll('فَتْحَهُ', 'فَتْحَهَا')
                  .replaceAll('نَصْرَهُ', 'نَصْرَهَا')
                  .replaceAll('نورَهُ', 'نُورَهَا')
                  .replaceAll('بَرَكَتَهُ', 'بَرَكَتَهَا')
                  .replaceAll('هُدَاهُ', 'هُدَاهَا')
                  .replaceAll('مَا فِيهِ', 'مَا فِيهَا')
                  .replaceAll('مَا بَعْدَهُ', 'مَا بَعْدَهَا');
            }
            // Item 90: أصبحنا -> أمسينا
            else if (item.id == 90) {
              updatedText = updatedText.replaceAll('أَصْبَحْنا', 'أَمْسَيْنَا');
            }

            return ZikrItem(
              id: item.id,
              arabicText: updatedText,
              repeat: item.repeat,
              audio: item.audio,
              translatedText: item.translatedText,
            );
          }).toList();
        }
      }

      emit(AzkarDetailsLoaded(zikrList));
    } catch (e) {
      emit(AzkarError(e.toString()));
    }
  }
}
