class AzkarCategory {
  final int id;
  final String title;

  AzkarCategory({required this.id, required this.title});

  factory AzkarCategory.fromJson(Map<String, dynamic> json) {
    return AzkarCategory(id: json['ID'], title: json['TITLE']);
  }

  static List<AzkarCategory> azkar = [
    AzkarCategory(id: 1, title: 'أذكار الاستيقاظ من النوم'),
    AzkarCategory(id: 2, title: 'الذكر عند لبس الثوب'),
    AzkarCategory(id: 3, title: 'الذكر عند الخروج من المنزل'),
    AzkarCategory(id: 4, title: 'الذكر عند دخول المنزل'),
    AzkarCategory(id: 5, title: 'أذكار الصباح'),
    AzkarCategory(id: 6, title: 'أذكار المساء'),
    AzkarCategory(id: 7, title: 'أذكار النوم'),
    AzkarCategory(id: 8, title: 'الذكر قبل الوضوء'),
    AzkarCategory(id: 9, title: 'الذكر بعد الوضوء'),
    AzkarCategory(id: 10, title: 'الذكر عند دخول المسجد'),
    AzkarCategory(id: 11, title: 'الذكر عند الخروج من المسجد'),
    AzkarCategory(id: 12, title: 'الذكر عند الأذان'),
    AzkarCategory(id: 13, title: 'دعاء الاستخارة'),
    AzkarCategory(id: 14, title: 'دعاء القنوت'),
    AzkarCategory(id: 15, title: 'أذكار بعد الصلاة'),
    AzkarCategory(id: 16, title: 'أذكار الكرب والضيق'),
    AzkarCategory(id: 17, title: 'دعاء السفر'),
    AzkarCategory(id: 18, title: 'الذكر عند الطعام'),
    AzkarCategory(id: 19, title: 'الذكر بعد الطعام'),
    AzkarCategory(id: 20, title: 'الذكر عند رؤية الهلال'),
    AzkarCategory(id: 21, title: 'دعاء الاستغفار'),
    AzkarCategory(id: 22, title: 'التسبيح والتحميد'),
    AzkarCategory(id: 23, title: 'الصلاة على النبي ﷺ'),
    AzkarCategory(id: 24, title: 'دعاء كفارة المجلس'),
    AzkarCategory(id: 25, title: 'دعاء الرياح'),
    AzkarCategory(id: 26, title: 'دعاء عند نزول المطر'),
    AzkarCategory(id: 27, title: 'دعاء الهم والحزن'),
    AzkarCategory(id: 28, title: 'دعاء المريض'),
    AzkarCategory(id: 29, title: 'دعاء المظلوم'),
    AzkarCategory(id: 30, title: 'دعاء الخوف من العدو'),
  ];
}
