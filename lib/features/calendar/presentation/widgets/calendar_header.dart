import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:hijri/hijri_calendar.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final VoidRefCallback onPrevMonth;
  final VoidRefCallback onNextMonth;

  const CalendarHeader({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  String _getHijriDateString(DateTime date) {
    final hijri = HijriCalendar.fromDate(date);
    String dateStr = "${hijri.hYear} ${hijri.longMonthName} ${hijri.hDay}";
    return FormatHelper.replaceWithArabicNumbers(dateStr);
  }

  @override
  Widget build(BuildContext context) {
    // Format Gregorian month name
    final formatter = DateFormat('MMMM yyyy', 'ar');
    final monthName = formatter.format(focusedMonth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 18, color: AppColors.primaryColor),
                onPressed: onPrevMonth,
              ),
              Text(
                FormatHelper.replaceWithArabicNumbers(monthName),
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.primaryColor),
                onPressed: onNextMonth,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text(
            "التاريخ الهجري: ${_getHijriDateString(selectedDate)}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

typedef VoidRefCallback = void Function();
