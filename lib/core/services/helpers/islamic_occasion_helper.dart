import 'package:hijri/hijri_calendar.dart';

class IslamicOccasion {
  final String name;
  final String description;
  final int month; // Hijri month (1–12)
  final int day; // Hijri day

  const IslamicOccasion({
    required this.name,
    required this.description,
    required this.month,
    required this.day,
  });
}

class IslamicOccasionHelper {
  static const List<IslamicOccasion> _occasions = [
    // Muharram
    IslamicOccasion(
      name: 'رأس السنة الهجرية',
      description:
          'يوم مبارك يُستحب فيه الشكر والدعاء واستقبال العام الجديد بعزيمة على الطاعة.',
      month: 1,
      day: 1,
    ),
    IslamicOccasion(
      name: 'يوم عاشوراء',
      description: 'يوم فضيل صامه موسى عليه السلام شكرًا لله، ويُستحب صيامه.',
      month: 1,
      day: 10,
    ),
    // Rabi al-Awwal
    IslamicOccasion(
      name: 'المولد النبوي الشريف',
      description:
          'ذكرى مولد سيد الخلق محمد صلى الله عليه وسلم، اغتنم بالصلاة عليه.',
      month: 3,
      day: 12,
    ),
    // Rajab
    IslamicOccasion(
      name: 'ليلة الإسراء والمعراج',
      description:
          'ذكرى رحلة النبي ﷺ المعجزة إلى بيت المقدس وعروجه إلى السماوات العلا.',
      month: 7,
      day: 27,
    ),
    // Sha'ban
    IslamicOccasion(
      name: 'ليلة النصف من شعبان',
      description:
          'ليلة مباركة يُستحب فيها الإكثار من الدعاء والاستغفار وذكر الله.',
      month: 8,
      day: 15,
    ),
    // Ramadan
    IslamicOccasion(
      name: 'شهر رمضان المبارك',
      description:
          'شهر الصيام والقرآن والرحمة والمغفرة، اغتنم أيامه وليالي الطاعات.',
      month: 9,
      day: 1,
    ),
    IslamicOccasion(
      name: 'ليلة القدر',
      description:
          'تعرّف على فضلها والأعمال المستحبة فيها، وابدأ الاستعداد لها بخطوات بسيطة.',
      month: 9,
      day: 27,
    ),
    // Shawwal
    IslamicOccasion(
      name: 'عيد الفطر المبارك',
      description:
          'يوم الفرحة والسرور بعد صيام رمضان، اجعله يومًا للشكر وصلة الأرحام.',
      month: 10,
      day: 1,
    ),
    // Dhul Hijja
    IslamicOccasion(
      name: 'أول أيام ذي الحجة',
      description:
          'أفضل أيام الدنيا، يُستحب فيها الصيام والذكر والتكبير والتهليل.',
      month: 12,
      day: 1,
    ),
    IslamicOccasion(
      name: 'يوم التروية',
      description:
          'اليوم الثامن من ذي الحجة، يتوجه فيه الحجاج إلى منى استعدادًا للوقوف بعرفة.',
      month: 12,
      day: 8,
    ),
    IslamicOccasion(
      name: 'يوم عرفة',
      description: 'أعظم أيام الدنيا، صيامه يكفّر سنتين، والدعاء فيه مستجاب.',
      month: 12,
      day: 9,
    ),
    IslamicOccasion(
      name: 'عيد الأضحى المبارك',
      description:
          'يوم النحر وذبح الأضاحي، اجعله يومًا للفرحة والعطاء والتقرب إلى الله.',
      month: 12,
      day: 10,
    ),
  ];

  /// Returns the next upcoming [IslamicOccasion] and the number of days
  /// remaining until it, based on a reference date (defaults to today).
  static ({IslamicOccasion occasion, int daysRemaining}) getNextOccasion([
    DateTime? referenceDate,
  ]) {
    final ref = referenceDate ?? DateTime.now();
    final today = HijriCalendar.fromDate(ref);
    final todayVal = today.hMonth * 100 + today.hDay;

    // Score each occasion: negative means it's already past this Hijri year.
    IslamicOccasion? best;
    int bestScore = 999999;

    for (final occ in _occasions) {
      final occVal = occ.month * 100 + occ.day;
      // Days difference within the same year (approximate – Hijri year ~354 days)
      int score = occVal - todayVal;
      if (score < 0) score += 354 * 100; // wrap to next year
      if (score < bestScore) {
        bestScore = score;
        best = occ;
      }
    }

    // Convert bestScore back to approximate days (score units = month*100+day diff)
    // More accurate: compute via Gregorian conversion
    final daysRemaining = _daysUntil(best!.month, best.day, today, ref);

    return (occasion: best, daysRemaining: daysRemaining);
  }

  static int _daysUntil(
    int hMonth,
    int hDay,
    HijriCalendar today,
    DateTime ref,
  ) {
    // Try this Hijri year first
    HijriCalendar target;
    try {
      target = HijriCalendar()
        ..hYear = today.hYear
        ..hMonth = hMonth
        ..hDay = hDay;
      final gTarget = target.hijriToGregorian(today.hYear, hMonth, hDay);
      final diff = DateTime(
        gTarget.year,
        gTarget.month,
        gTarget.day,
      ).difference(DateTime(ref.year, ref.month, ref.day)).inDays;
      if (diff >= 0) return diff;
    } catch (_) {}

    // If past, try next Hijri year
    try {
      final gTarget = today.hijriToGregorian(today.hYear + 1, hMonth, hDay);
      return DateTime(
        gTarget.year,
        gTarget.month,
        gTarget.day,
      ).difference(DateTime(ref.year, ref.month, ref.day)).inDays;
    } catch (_) {
      return 0;
    }
  }
}
