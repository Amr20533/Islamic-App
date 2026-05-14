class SurahCategory {
  final int number;
  final String name;
  final String revelationPlace; // مدنية أو مكية
  final int versesCount;
  final int wordsCount;
  final int lettersCount;

  SurahCategory({
    required this.number,
    required this.name,
    required this.revelationPlace,
    required this.versesCount,
    required this.wordsCount,
    required this.lettersCount,
  });

  // تحويل من JSON إلى Object
  factory SurahCategory.fromJson(Map<String, dynamic> json) {
    return SurahCategory(
      number: json['number'],
      name: json['name'],
      revelationPlace: json['revelation_place'],
      versesCount: json['verses_count'],
      wordsCount: json['words_count'],
      lettersCount: json['letters_count'],
    );
  }

  // قائمة ثابتة للسور (أمثلة)
  static List<SurahCategory> surahCategories = [
    SurahCategory(
      number: 1,
      name: "الفاتحة",
      revelationPlace: "مكية",
      versesCount: 7,
      wordsCount: 29,
      lettersCount: 139,
    ),
    SurahCategory(
      number: 2,
      name: "البقرة",
      revelationPlace: "مدنية",
      versesCount: 286,
      wordsCount: 6144,
      lettersCount: 25613,
    ),
    SurahCategory(
      number: 3,
      name: "آل عمران",
      revelationPlace: "مدنية",
      versesCount: 200,
      wordsCount: 3480,
      lettersCount: 14525,
    ),
  ];
}
