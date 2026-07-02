class DateConstants {
  static final years = List.generate(
    100,
    (index) => (DateTime.now().year - index).toString(),
  );

  static const months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  static final days = List.generate(31, (index) => (index + 1).toString());
}
