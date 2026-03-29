import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:islamic_app/core/models/azkar/azkar_category.dart';
import 'package:islamic_app/core/models/azkar/zikr_item.dart';

class DailyDhikrController extends GetxController {
  final RxInt count = 0.obs;
  final int maxCount = 10;

  @override
  void onInit() {
    super.onInit();
  }

  void incrementCount() {
    if(count.value < maxCount){
      count.value += 1;
    } else {
        count.value = maxCount;
      }
    }


  void resetCount() {
    count.value = 0;
  }

  bool get isCompleted => count.value >= maxCount;

}