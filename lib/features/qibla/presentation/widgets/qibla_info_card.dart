import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

/// Displays a single info card (e.g. "اتجاه القبلة 130°").
class QiblaInfoCard extends StatelessWidget {
  final String title;
  final double? value;

  const QiblaInfoCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final String displayValue = value != null
        ? '${value!.toStringAsFixed(0)}°'
        : '--°';

    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 12,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            displayValue,
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 26,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
