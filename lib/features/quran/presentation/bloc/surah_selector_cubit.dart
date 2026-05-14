import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/quran/presentation/widgets/surah_slider.dart';

class SurahSelectorCubit extends Cubit<int> {
  SurahSelectorCubit() : super(0);

  final List<String> categories = ['سور', 'أجزاء', 'صفحات'];

  final List<Widget> pages = [const SurahSlider(), Container(), Container()];

  void updateIndex(int index) {
    emit(index);
  }
}
