import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/core/controllers/quran_controller.dart';
import 'package:islamic_app/core/models/quran/surah_category.dart';
import 'package:islamic_app/core/models/verse.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/views/surah_details_view.dart';
import 'package:islamic_app/widgets/fatiha.dart';
import 'package:islamic_app/widgets/surah_banner.dart';
import 'package:islamic_app/widgets/surah_header.dart';

// 1. القائمة الرئيسية للسور
class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم Get.find لأننا غالباً قمنا بحقن الكنترولر في البداية
    final controller = locator<QuranController>();

    return ListView.builder(
      itemCount: SurahCategory.surahCategories.length,
      itemBuilder: (context, index) {
        final cat = SurahCategory.surahCategories[index];
        return ListTile(
          title: Text(cat.name, textAlign: TextAlign.right),
          subtitle: Text("سورة رقم ${index + 1}", textAlign: TextAlign.right, style: const TextStyle(fontSize: 10)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () async {
            // تحميل البيانات قبل الانتقال لضمان تجربة مستخدم سلسة
            await controller.loadSurahData(index + 1);
            Get.to(() => SurahDetailsView(surahName: cat.name));
          },
        );
      },
    );
  }
}

