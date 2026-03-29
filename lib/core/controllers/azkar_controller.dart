import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:islamic_app/core/models/azkar/azkar_category.dart';
import 'package:islamic_app/core/models/azkar/zikr_item.dart';


class AzkarController extends GetxController {
  var categories = <AzkarCategory>[].obs;
  var currentZikrList = <ZikrItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  // Load only Titles for the main list (Low memory)
  Future<void> loadCategories() async {
    final String response = await rootBundle.loadString('assets/azkar.json');
    final List<dynamic> data = json.decode(response);
    categories.value = data.map((e) => AzkarCategory.fromJson(e)).toList();
  }

  // Load full details only for the selected ID (On-demand)
  Future<void> loadZikrDetails(int id) async {
    isLoading(true);
    final String response = await rootBundle.loadString('assets/azkar/azkar.json');
    final List<dynamic> data = json.decode(response);

    // Find the specific object by ID
    final selected = data.firstWhere((element) => element['ID'] == id);

    // The JSON structure has a dynamic key (the title), so we access the first ZIKR map
    final List<dynamic> zikrData = selected['ZIKR'][0].values.first;

    currentZikrList.value = zikrData.map((z) => ZikrItem(
      arabicText: z['ARABIC_TEXT'],
      repeat: z['REPEAT'],
      audio: z['AUDIO'], id: z['ID'],
      translatedText: z['TRANSLATED_TEXT'],
    )).toList();

    isLoading(false);
  }
}