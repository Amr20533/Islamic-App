import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/widgets/quran/surah_slider.dart';

class SurahSelectorController extends GetxController {
  // Observable index
  final _selectedIndex = 0.obs;

  // Getter/Setter
  int get selectedIndex => _selectedIndex.value;

  void updateIndex(int index) {
    _selectedIndex.value = index;
  }

  final List<String> categories = [
    'سور',
    'أجزاء',
    'صفحات',
  ];

  final List<Widget> pages = [
    SurahSlider(),
    Container(),
    Container(),
  ];
}