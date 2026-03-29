import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/verse.dart';

class QuranController extends GetxController {
  // تخزين الآيات مقسمة حسب رقم الصفحة داخل السورة الحالية
  var pagesInCurrentSurah = <int, List<Verse>>{}.obs;
  var isLoading = false.obs;

  Future<void> loadSurahData(int surahNumber) async {
    isLoading(true);
    try {
      final String response = await rootBundle.loadString('assets/surah/surah_$surahNumber.json');
      final data = json.decode(response);
      List versesData = data['verses'];

      Map<int, List<Verse>> tempPages = {};

      for (var v in versesData) {
        Verse verse = Verse.fromJson(v);
        // تجميع الآيات بناءً على رقم الصفحة
        if (!tempPages.containsKey(verse.page)) {
          tempPages[verse.page] = [];
        }
        tempPages[verse.page]!.add(verse);
      }

      pagesInCurrentSurah.value = tempPages;
    } finally {
      isLoading(false);
    }
  }

  // الحصول على أرقام الصفحات مرتبة
  List<int> get sortedPageNumbers => pagesInCurrentSurah.keys.toList()..sort();
}