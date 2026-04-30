import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/views/adan_view.dart';
import 'package:islamic_app/views/home/home_view.dart';
import 'package:islamic_app/views/quran_view.dart';
import 'package:islamic_app/views/zikr_view.dart';

class MainController extends GetxController {
  final count = 0.obs;

  // 1. Define the current index
  final currentIndex = 0.obs;

  // 2. Define the pages here so the View can access them
  final List<Widget> pages = [
    HomeView(),
    const QuranView(),
    // AdanView(),
    ZikrView(),
    const QuranView(),
    const Center(child: SizedBox.shrink(),),
  ];

  void increment() {
    count.value++;
  }

  // 3. Define the changePage method
  void changePage(int index) {
    currentIndex.value = index;
  }
}