// class Verse {
//   final int? id;
//   final String text;
//   final int page;
//   final int verseNumber;
//   String? surahNameAr;
//   int? surahNumber;
//
//   Verse({
//     required this.id,
//     required this.text,
//     required this.page,
//     required this.verseNumber,
//     this.surahNameAr,
//     this.surahNumber
//   });
//
//   factory Verse.fromJson(Map<String, dynamic> json) {
//     return Verse(
//       id: json['number'],
//       text: json['text'], // النص العربي للآية
//       page: json['page'],
//       verseNumber: json['numberInSurah'],
//     );
//   }
// }

class Verse {
  int? number;
  Map<String, dynamic>? text; // قمت بإعادته لـ Map لأنك تستخدم ['ar'] في العرض
  int? juz, surahNumber;
  String? surahNameAr; // الاسم العربي للسورة
  bool? sajda;
  final int page;


  Verse({this.number, this.text, this.juz, required this.page, this.sajda, this.surahNameAr, this.surahNumber});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      juz: json['juz'],
      page: json['page'],
      sajda: json['sajda'] is bool ? json['sajda'] : false,
      text: json['text'], // نمرر الخريطة كاملة
      number: json['number'] as int?,
    );
  }
}