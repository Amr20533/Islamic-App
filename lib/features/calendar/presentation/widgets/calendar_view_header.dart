import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class CalendarViewHeader extends StatelessWidget {
  final String hijriDate;
  final String gregorianDate;

  const CalendarViewHeader({
    super.key,
    required this.hijriDate,
    required this.gregorianDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        const Text(
          'التقويم',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.counterColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hijriDate,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.thirdTextColor,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 1,
              height: 16,
              color: AppColors.borderColor,
            ),
            const SizedBox(width: 16),
            Text(
              gregorianDate,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.thirdTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
