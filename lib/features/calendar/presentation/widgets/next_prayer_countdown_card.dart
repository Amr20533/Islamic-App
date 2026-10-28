import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/utils/app_responsive.dart';

class NextPrayerCountdownCard extends StatelessWidget {
  final String nextPrayerName;
  final String countdown;

  const NextPrayerCountdownCard({
    super.key,
    required this.nextPrayerName,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    final parts = countdown.split(':');
    final hours = parts.isNotEmpty ? parts[0] : '00';
    final minutes = parts.length > 1 ? parts[1] : '00';
    final seconds = parts.length > 2 ? parts[2] : '00';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardHeight = AppResponsive.value<double>(
      context,
      mobile: 160,
      tablet: 150,
      web: 170,
    );

    return Container(
      height: cardHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242220) : null,
        borderRadius: BorderRadius.circular(20.r),
        border: isDark
            ? Border.all(color: const Color(0xFF383430), width: 1)
            : null,
        image: DecorationImage(
          image: const ResizeImage(
            width: 800,
            AssetImage('assets/images/image.png'),
          ),
          fit: BoxFit.cover,
          colorFilter: isDark
              ? ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.7),
                  BlendMode.darken,
                )
              : null,
        ),
        boxShadow: isDark
            ? const []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "الصلاة القادمة",
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: AppResponsive.fontSize(context, mobile: 16, tablet: 13, web: 15),
              fontWeight: FontWeight.w500,
              color: isDark
                  ? const Color(0xFFB8AEA5)
                  : AppColors.thirdTextColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            nextPrayerName,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: AppResponsive.fontSize(context, mobile: 20, tablet: 16, web: 18),
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFF5F2EE) : AppColors.counterColor,
            ),
          ),
          SizedBox(height: 10.h),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TimeUnit(value: hours, label: "ساعة", isDark: isDark),
                _Colon(isDark: isDark),
                _TimeUnit(value: minutes, label: "دقيقة", isDark: isDark),
                _Colon(isDark: isDark),
                _TimeUnit(value: seconds, label: "ثانيه", isDark: isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;

  const _TimeUnit({
    required this.value,
    required this.label,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final numSize = AppResponsive.fontSize(context, mobile: 20, tablet: 16, web: 18);
    final lblSize = AppResponsive.fontSize(context, mobile: 12, tablet: 10, web: 11);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: numSize,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFFF5F2EE) : AppColors.counterColor,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: lblSize,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFFB8AEA5) : AppColors.thirdTextColor,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class _Colon extends StatelessWidget {
  final bool isDark;

  const _Colon({this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final numSize = AppResponsive.fontSize(context, mobile: 20, tablet: 16, web: 18);
    final lblSize = AppResponsive.fontSize(context, mobile: 12, tablet: 10, web: 11);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          ':',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: numSize,
            fontWeight: FontWeight.bold,
            color: isDark
                ? const Color(0xFFC8A88A)
                : AppColors.primaryTextColor,
            height: 1.0,
          ),
        ),
        SizedBox(height: 6.h),
        Opacity(
          opacity: 0,
          child: Text(
            'دقيقة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: lblSize,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}
