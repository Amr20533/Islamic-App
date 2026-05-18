import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/quran/presentation/widgets/surah_slider.dart';
import 'package:islamic_app/features/quran/presentation/widgets/juz_slider.dart';
import 'package:islamic_app/features/quran/presentation/widgets/page_slider.dart';

class SurahSelectorCubit extends Cubit<int> {
  SurahSelectorCubit() : super(0);

  final List<String> categories = ['سور', 'أجزاء', 'صفحات'];

  final List<Widget> pages = [
    const SurahSlider(),
    const JuzSlider(),
    const PageSlider(),
  ];

  void updateIndex(int index) {
    emit(index);
  }
}
