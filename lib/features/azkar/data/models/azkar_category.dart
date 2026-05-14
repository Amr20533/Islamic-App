class AzkarCategory {
  final int id;
  final String title;

  AzkarCategory({required this.id, required this.title});

  factory AzkarCategory.fromJson(Map<String, dynamic> json) {
    return AzkarCategory(id: json['ID'], title: json['TITLE']);
  }
  static List<AzkarCategory> azkar = [
    AzkarCategory(id: 27, title: 'أذكار الصباح والمساء'),
    AzkarCategory(id: 28, title: 'أذكار النوم'),
    AzkarCategory(id: 1, title: 'أذكار الاستيقاظ من النوم'),
    AzkarCategory(id: 8, title: 'الذكر قبل الوضوء'),
    AzkarCategory(id: 10, title: 'الذكر عند الخروج من المنزل'),
    AzkarCategory(id: 15, title: 'أذكار الآذان'),
    AzkarCategory(id: 105, title: 'ذكر الرجوع من السفر'),
    AzkarCategory(id: 120, title: 'الذكر عند المشعر الحرام'),
  ];
}
