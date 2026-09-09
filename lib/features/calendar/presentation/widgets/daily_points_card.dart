import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';

class DailyPointsCard extends StatelessWidget {
  final int totalPoints;

  const DailyPointsCard({super.key, required this.totalPoints});

  String _getMotivationalQuote(int points) {
    if (points == 0) {
      return "ابدأ يومك بالصلاة والذكر لتكسب الحسنات والبركة! 🌱";
    } else if (points < 40) {
      return "خطوة مباركة! استمر في أداء السنن لتزيد نقاطك وأجرك عند الله. 🌿";
    } else if (points < 80) {
      return "أداء ممتاز ومحافظة رائعة اليوم! تقبل الله منك طاعتك الصالحة. ✨";
    } else {
      return "ما شاء الله! متميز ومحافظ على العبادات والسنن كأنك تؤسس بيتاً بالجنة. 🌟";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF383028), const Color(0xFF24201C)]
              : [AppColors.primaryColor, AppColors.secondaryColor],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: const Color(0xFF383430), width: 1) : null,
        boxShadow: isDark
            ? const []
            : [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        children: [
          Text(
            'مجموع نقاط اليوم',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFC8A88A) : Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                FormatHelper.replaceWithArabicNumbers(totalPoints.toString()),
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFF5F2EE) : Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'نقطة',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFB8AEA5) : Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getMotivationalQuote(totalPoints),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 13,
              color: isDark ? const Color(0xFFF5F2EE) : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
