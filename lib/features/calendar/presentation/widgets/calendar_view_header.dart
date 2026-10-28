import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/utils/app_responsive.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleSize = AppResponsive.fontSize(context, mobile: 22, tablet: 18, web: 20);
    final dateSize = AppResponsive.fontSize(context, mobile: 16, tablet: 13, web: 14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 24.h),
        Text(
          'التقويم',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: titleSize,
            fontWeight: FontWeight.w900,
            color: isDark ? const Color(0xFFC8A88A) : AppColors.counterColor,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hijriDate,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: dateSize,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFF5F2EE) : AppColors.thirdTextColor,
              ),
            ),
            SizedBox(width: 16.w),
            Container(
              width: 1.w,
              height: 16.h,
              color: isDark ? const Color(0xFF383430) : AppColors.borderColor,
            ),
            SizedBox(width: 16.w),
            Text(
              gregorianDate,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: dateSize,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFF5F2EE) : AppColors.thirdTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
