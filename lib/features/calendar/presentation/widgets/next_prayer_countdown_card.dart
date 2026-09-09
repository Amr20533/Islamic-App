import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

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

    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242220) : null,
        borderRadius: BorderRadius.circular(20),
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
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "الصلاة القادمة",
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFB8AEA5) : AppColors.thirdTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nextPrayerName,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFF5F2EE) : AppColors.counterColor,
            ),
          ),
          const SizedBox(height: 10),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFFF5F2EE) : AppColors.counterColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 12,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          ':',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFFC8A88A) : AppColors.primaryTextColor,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        const Opacity(
          opacity: 0,
          child: Text(
            'دقيقة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}
