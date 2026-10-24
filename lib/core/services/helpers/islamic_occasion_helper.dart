import 'package:hijri/hijri_calendar.dart';

import 'package:hijri/hijri_calendar.dart';

class IslamicOccasion {
  final String id;
  final String name;
  final String description;
  final int month; // Hijri month (1–12)
  final int day; // Hijri day

  /// True if the occasion is observed on the *night* before this Hijri day
  /// (the Islamic day begins at sunset), e.g. Laylat al-Qadr.
  final bool isNight;

  const IslamicOccasion({
    required this.id,
    required this.name,
    required this.description,
    required this.month,
    required this.day,
    this.isNight = false,
  });

  factory IslamicOccasion.fromJson(Map<String, dynamic> j) => IslamicOccasion(
        id: j['id'] as String,
        name: j['name'] as String,
        description: j['description'] as String,
        month: j['month'] as int,
        day: j['day'] as int,
        isNight: (j['isNight'] as bool?) ?? false,
      );
}

class OccasionResult {
  final IslamicOccasion occasion;
  final int daysRemaining;
  final DateTime gregorianDate;

  const OccasionResult(this.occasion, this.daysRemaining, this.gregorianDate);

  bool get isToday => daysRemaining == 0;
}

class IslamicOccasionHelper {
  /// Defaults. You can replace these at runtime (Remote Config / JSON / API)
  /// via [setOccasions].
  static List<IslamicOccasion> _occasions = _defaults;

  static void setOccasions(List<IslamicOccasion> list) => _occasions = list;

  static List<IslamicOccasion> parseJson(List<dynamic> json) =>
      json.map((e) => IslamicOccasion.fromJson(e as Map<String, dynamic>)).toList();

  /// [dayAdjustment]: shift the Hijri calendar to match local moon sighting
  /// (e.g. -1, 0, +1). Store it in settings so users can tweak it.
  static OccasionResult getNextOccasion({
    DateTime? referenceDate,
    int dayAdjustment = 0,
  }) {
    final ref = referenceDate ?? DateTime.now();
    final todayUtc = DateTime.utc(ref.year, ref.month, ref.day);

    // Hijri "today" after adjustment
    final hijriToday = HijriCalendar.fromDate(
      todayUtc.add(Duration(days: dayAdjustment)),
    );

    OccasionResult? best;

    // Check this Hijri year and the next one (covers year wrap-around).
    for (final year in [hijriToday.hYear, hijriToday.hYear + 1]) {
      for (final occ in _occasions) {
        final date = _toGregorian(year, occ, dayAdjustment);
        if (date == null) continue;

        final diff = date.difference(todayUtc).inDays;
        if (diff < 0) continue;

        if (best == null || diff < best.daysRemaining) {
          best = OccasionResult(occ, diff, date);
        }
      }
    }

    // Practically unreachable, but keeps the return type non-null.
    return best ?? OccasionResult(_occasions.first, 0, todayUtc);
  }

  static DateTime? _toGregorian(int hYear, IslamicOccasion occ, int adjust) {
    try {
      final g = HijriCalendar().hijriToGregorian(hYear, occ.month, occ.day);
      // Night occasions begin the evening before; adjustment is reversed
      // because we're converting Hijri -> Gregorian.
      final shift = (occ.isNight ? -1 : 0) - adjust;
      return DateTime.utc(g.year, g.month, g.day + shift);
    } catch (_) {
      return null; // out of the package's supported range
    }
  }

  static const List<IslamicOccasion> _defaults = [
    IslamicOccasion(
      id: 'hijri_new_year',
      name: 'رأس السنة الهجرية',
      description:
          'يوم مبارك يُستحب فيه الشكر والدعاء واستقبال العام الجديد بعزيمة على الطاعة.',
      month: 1,
      day: 1,
    ),
    IslamicOccasion(
      id: 'ashura',
      name: 'يوم عاشوراء',
      description: 'يوم فضيل صامه موسى عليه السلام شكرًا لله، ويُستحب صيامه.',
      month: 1,
      day: 10,
    ),
    IslamicOccasion(
      id: 'mawlid',
      name: 'المولد النبوي الشريف',
      description:
          'ذكرى مولد سيد الخلق محمد صلى الله عليه وسلم، اغتنم بالصلاة عليه.',
      month: 3,
      day: 12,
    ),
    IslamicOccasion(
      id: 'isra_miraj',
      name: 'ليلة الإسراء والمعراج',
      description:
          'ذكرى رحلة النبي ﷺ المعجزة إلى بيت المقدس وعروجه إلى السماوات العلا.',
      month: 7,
      day: 27,
      isNight: true,
    ),
    IslamicOccasion(
      id: 'nisf_shaban',
      name: 'ليلة النصف من شعبان',
      description:
          'ليلة مباركة يُستحب فيها الإكثار من الدعاء والاستغفار وذكر الله.',
      month: 8,
      day: 15,
      isNight: true,
    ),
    IslamicOccasion(
      id: 'ramadan',
      name: 'شهر رمضان المبارك',
      description:
          'شهر الصيام والقرآن والرحمة والمغفرة، اغتنم أيامه وليالي الطاعات.',
      month: 9,
      day: 1,
    ),
    IslamicOccasion(
      id: 'laylat_qadr',
      name: 'ليلة القدر',
      description:
          'تعرّف على فضلها والأعمال المستحبة فيها، وابدأ الاستعداد لها بخطوات بسيطة.',
      month: 9,
      day: 27,
      isNight: true,
    ),
    IslamicOccasion(
      id: 'eid_fitr',
      name: 'عيد الفطر المبارك',
      description:
          'يوم الفرحة والسرور بعد صيام رمضان، اجعله يومًا للشكر وصلة الأرحام.',
      month: 10,
      day: 1,
    ),
    IslamicOccasion(
      id: 'dhul_hijja_first',
      name: 'أول أيام ذي الحجة',
      description:
          'أفضل أيام الدنيا، يُستحب فيها الصيام والذكر والتكبير والتهليل.',
      month: 12,
      day: 1,
    ),
    IslamicOccasion(
      id: 'tarwiyah',
      name: 'يوم التروية',
      description:
          'اليوم الثامن من ذي الحجة، يتوجه فيه الحجاج إلى منى استعدادًا للوقوف بعرفة.',
      month: 12,
      day: 8,
    ),
    IslamicOccasion(
      id: 'arafah',
      name: 'يوم عرفة',
      description: 'أعظم أيام الدنيا، صيامه يكفّر سنتين، والدعاء فيه مستجاب.',
      month: 12,
      day: 9,
    ),
    IslamicOccasion(
      id: 'eid_adha',
      name: 'عيد الأضحى المبارك',
      description:
          'يوم النحر وذبح الأضاحي، اجعله يومًا للفرحة والعطاء والتقرب إلى الله.',
      month: 12,
      day: 10,
    ),
  ];
}
