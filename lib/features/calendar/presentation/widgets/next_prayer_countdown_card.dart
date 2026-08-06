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

    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: ResizeImage(
              width: 800,
              AssetImage('assets/images/image.png'),
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
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
          const Text(
            "الصلاة القادمة",
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.thirdTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nextPrayerName,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.counterColor,
            ),
          ),
          const SizedBox(height: 10),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TimeUnit(value: hours, label: "ساعة"),
                const _Colon(),
                _TimeUnit(value: minutes, label: "دقيقة"),
                const _Colon(),
                _TimeUnit(value: seconds, label: "ثانيه"),
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

  const _TimeUnit({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.counterColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.thirdTextColor,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class _Colon extends StatelessWidget {
  const _Colon();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          ':',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTextColor,
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
