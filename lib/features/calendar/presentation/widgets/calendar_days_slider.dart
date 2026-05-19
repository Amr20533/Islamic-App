import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';

class CalendarDaysSlider extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const CalendarDaysSlider({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onDateSelected,
  });

  List<DateTime> _getDaysInMonth(DateTime monthDate) {
    final year = monthDate.year;
    final month = monthDate.month;
    final totalDays = DateUtils.getDaysInMonth(year, month);
    return List.generate(totalDays, (i) => DateTime(year, month, i + 1));
  }

  @override
  Widget build(BuildContext context) {
    final daysList = _getDaysInMonth(focusedMonth);

    return SizedBox(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: daysList.length,
        itemBuilder: (context, index) {
          final date = daysList[index];
          final isSelected = date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;
          final isToday = date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day;

          final dayName = DateFormat('E', 'ar').format(date);
          final dayNum = FormatHelper.replaceWithArabicNumbers(date.day.toString());

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : (isToday ? AppColors.thirdColor.withOpacity(0.4) : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : (isToday ? AppColors.primaryColor : Colors.grey[200]!),
                  width: isToday || isSelected ? 1.5 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 13,
                      color: isSelected ? Colors.white : AppColors.hintTextColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dayNum,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
