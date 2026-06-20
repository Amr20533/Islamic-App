import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class FormatHelper{
  static String getHijriFormattedDate({DateTime? dateTime, String locale = 'ar'}) {
    HijriCalendar.setLocal(locale);
    final hijri = dateTime != null ? HijriCalendar.fromDate(dateTime) : HijriCalendar.now();

    // Pattern from image: [Day] [Month Name] [Year]
    String date = "${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear}";
    return replaceWithArabicNumbers(date);
  }

  static String getMiladFormattedDate({DateTime? dateTime, String locale = 'ar'}) {
    final milad = dateTime ?? DateTime.now();
    // Pattern from image: [Day] [Month Name] [Year]
    final formatter = DateFormat('d MMMM yyyy', locale);
    String formatted = formatter.format(milad);

    return replaceWithArabicNumbers(formatted);
  }

  static String formatTime12Hour(DateTime? dateTime, {String locale = 'ar'}) {
    if (dateTime == null) return "--:--";

    // Convert to local time zone to show accurate local prayer times
    final localDateTime = dateTime.toLocal();

    // 1. Format the time
    final formatter = DateFormat('hh:mm a', locale);
    String formatted = formatter.format(localDateTime);

    // 2. If locale is Arabic, convert digits to Eastern Arabic numerals
    if (locale == 'ar') {
      return replaceWithArabicNumbers(formatted);
    }

    return formatted;
  }

  static String replaceWithArabicNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], arabic[i]);
    }
    return input;
  }


}
