// import 'package:flutter/material.dart';
// import 'package:islamic_app/core/controllers/quran_controller.dart';
// import 'package:islamic_app/core/models/surah_model.dart';
// import 'package:islamic_app/core/models/verse.dart';
// import 'package:islamic_app/di/locator.dart';
// import 'package:islamic_app/services/helpers/format_helper.dart';
// class MushafPage extends StatelessWidget {
//   final String surahName;
//   final int surahNumber;
//
//   const MushafPage({super.key, required this.surahName, required this.surahNumber});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = locator<QuranController>();
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBF9F1), // خلفية ورق المصحف
//       appBar: AppBar(
//         title: Text(surahName, style: const TextStyle(fontFamily: 'QuranFont')),
//         centerTitle: true,
//         backgroundColor: const Color(0xFFFBF9F1),
//         elevation: 0,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final pages = controller.sortedPageNumbers;
//
//         return PageView.builder(
//           reverse: true, // مهم جداً للتقليب من اليمين لليسار
//           itemCount: pages.length,
//           itemBuilder: (context, index) {
//             final pageNum = pages[index];
//             final verses = controller.pagesInCurrentSurah[pageNum]!;
//
//             return MushafPageWidget(
//                 verses: verses,
//                 pageNumber: pageNum
//             );
//           },
//         );
//       }),
//     );
//   }
// }
//
// class MushafPageWidget extends StatelessWidget {
//   final List<Verse> verses;
//   final int pageNumber;
//
//   const MushafPageWidget({super.key, required this.verses, required this.pageNumber});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               // نستخدم التمرير العمودي فقط إذا كان النص أطول من الشاشة (للأجهزة الصغيرة)
//               physics: const BouncingScrollPhysics(),
//               child: Directionality(
//                 textDirection: TextDirection.rtl,
//                 child: Text.rich(
//                   textAlign: TextAlign.justify,
//                   TextSpan(
//                     children: verses.map((v) => _buildVerseSpan(v)).toList(),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // رقم الصفحة في الأسفل
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Text(
//               FormatHelper.replaceWithArabicNumbers(pageNumber.toString()),
//               style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.brown.withOpacity(0.6),
//                   fontFamily: 'QuranFont'
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   InlineSpan _buildVerseSpan(Verse v) {
//     return TextSpan(
//       children: [
//         TextSpan(
//           text: "${v.text?['ar']} ",
//           style: const TextStyle(
//             fontSize: 24,
//             height: 2.1,
//             fontFamily: 'QuranFont',
//             color: Colors.black,
//           ),
//         ),
//         TextSpan(
//           text: "﴿${FormatHelper.replaceWithArabicNumbers(v.number.toString())}﴾ ",
//           style: const TextStyle(
//             fontSize: 20,
//             color: Color(0xFF8B4513),
//             fontFamily: 'QuranFont',
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class VerseWidget extends StatelessWidget {
//   final Verse verse;
//
//   const VerseWidget({super.key, required this.verse});
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Text.rich(
//           textAlign: TextAlign.justify,
//           TextSpan(
//             children: [
//               // نص الآية الكريمة
//               TextSpan(
//                 text: "${verse.text?['ar']} ",
//                 style: const TextStyle(
//                   fontSize: 24,
//                   height: 2.2,
//                   fontFamily: 'QuranFont',
//                   color: Colors.black,
//                 ),
//               ),
//               // رقم الآية مع الزخرفة
//               TextSpan(
//                 text: "﴿${FormatHelper.replaceWithArabicNumbers(verse.number.toString())}﴾ ",
//                 style: const TextStyle(
//                   fontSize: 20,
//                   color: Color(0xFF8B4513), // لون بني خشبي كلاسيكي
//                   fontFamily: 'QuranFont',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
