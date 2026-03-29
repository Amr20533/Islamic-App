import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class FormatHelper{
  static String getHijriFormattedDate({String locale = 'ar'}) {
    HijriCalendar.setLocal(locale);
    final hijri = HijriCalendar.now();

    // Pattern from image: [Year] [Month Name] [Day]
    // Note: RTL handles the visual order, but we provide the logic
    String date = "${hijri.hYear} ${hijri.longMonthName} ${hijri.hDay}";
    return replaceWithArabicNumbers(date);
  }

  static String getMiladFormattedDate({String locale = 'ar'}) {
    final milad = DateTime.now();
    // Pattern from image: [Year] [Month Name] [Day]
    final formatter = DateFormat('yyyy MMMM d', locale);
    String formatted = formatter.format(milad);

    return replaceWithArabicNumbers(formatted);
  }

  static String formatTime12Hour(DateTime? dateTime, {String locale = 'ar'}) {
    if (dateTime == null) return "--:--";

    // 1. Format the time
    final formatter = DateFormat('hh:mm a', locale);
    String formatted = formatter.format(dateTime);

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