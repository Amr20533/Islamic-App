import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/core/models/verse.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/services/helpers/format_helper.dart';
import '../core/controllers/quran_controller.dart';

// 2. شاشة عرض السورة (المسؤولة عن التقليب الأفقي)
class SurahDetailsView extends StatelessWidget {
  final String surahName;
  const SurahDetailsView({super.key, required this.surahName});

  @override
  Widget build(BuildContext context) {
    final controller = locator<QuranController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F1),
      appBar: AppBar(
        title: Text(surahName, style: const TextStyle(fontFamily: 'QuranFont')),
        centerTitle: true,
        backgroundColor: const Color(0xFFFBF9F1),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final pageNumbers = controller.sortedPageNumbers;

        if (pageNumbers.isEmpty) {
          return const Center(child: Text("لا توجد بيانات لهذه السورة"));
        }

        return PageView.builder(
          reverse: true, // التقليب من اليمين لليسار
          itemCount: pageNumbers.length,
          itemBuilder: (context, index) {
            final pageNum = pageNumbers[index];
            final versesInPage = controller.pagesInCurrentSurah[pageNum]!;

            return MushafPageWidget(
                verses: versesInPage,
                pageNumber: pageNum
            );
          },
        );
      }),
    );
  }
}

// 3. ويدجت محتوى الصفحة الواحدة
class MushafPageWidget extends StatelessWidget {
  final List<Verse> verses;
  final int pageNumber;

  const MushafPageWidget({super.key, required this.verses, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown, // سيقوم بتصغير النص ليتناسب مع مساحة الشاشة دون سحب
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // تحديد عرض ثابت ليعرف الـ FittedBox كيف يقلص النص
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text.rich(
                    textAlign: TextAlign.justify,
                    _buildTextSpan(verses),
                  ),
                ),
              ),
            ),
          ),
          // رقم الصفحة بتصميم كلاسيكي
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              FormatHelper.replaceWithArabicNumbers(pageNumber.toString()),
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.brown.withOpacity(0.7),
                  fontFamily: 'QuranFont',
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
  TextSpan _buildTextSpan(List<Verse> verses) {
    return TextSpan(
      children: verses.map((v) {
        return TextSpan(
          children: [
            // 1. نص الآية الكريمة
            TextSpan(
              text: "${v.text?['ar']} ",
              style: const TextStyle(
                fontSize: 24,
                height: 2.2, // تباعد الأسطر لراحة العين
                fontFamily: 'QuranFont',
                color: Colors.black,
              ),
            ),

            // 2. رقم الآية داخل الزخرفة
            TextSpan(
              text: "﴿${FormatHelper.replaceWithArabicNumbers(v.number.toString())}﴾ ",
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF8B4513), // لون بني خشبي
                fontFamily: 'QuranFont',
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  InlineSpan _buildVerseSpan(Verse v) {
    return TextSpan(
      children: [
        TextSpan(
          text: "${v.text?['ar']} ",
          style: const TextStyle(
            fontSize: 24,
            height: 2.2,
            fontFamily: 'QuranFont',
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: "﴿${FormatHelper.replaceWithArabicNumbers(v.number.toString())}﴾ ",
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF8B4513),
            fontFamily: 'QuranFont',
          ),
        ),
      ],
    );
  }
  double calculateFontSize(BoxConstraints constraints) {
    // معادلة بسيطة لتصغير الخط كلما قصرت الشاشة
    if (constraints.maxHeight < 500) return 18.0;
    if (constraints.maxHeight < 700) return 22.0;
    return 26.0;
  }
}