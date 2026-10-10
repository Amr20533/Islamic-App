import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/services/helpers/islamic_occasion_helper.dart';

class IslamicOccasionCard extends StatelessWidget {
  final IslamicOccasion occasion;

  const IslamicOccasionCard({
    super.key,
    required this.occasion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
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
            AssetImage(
              'assets/images/Gemini_Generated_Image_p06u05p06u05p06u (1) 1.png',
            ),
          ),
          fit: BoxFit.cover,
          colorFilter: isDark
              ? ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.75),
                  BlendMode.darken,
                )
              : null,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "المناسبة الدينية القادمة",
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFFB8AEA5) : AppColors.thirdTextColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              occasion.name,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFF5F2EE) : AppColors.counterColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              "استعد لهذه المناسبة المباركة 🌿",
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              occasion.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                height: 1.5,
                color: isDark ? const Color(0xFFB8AEA5) : AppColors.hintTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
