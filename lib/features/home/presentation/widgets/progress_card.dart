import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/services/streak_notifier.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/di/locator.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key, required this.icon, required this.leading});

  final String icon;
  final String leading;

  String _streakText(int streak) {
    if (streak == 0) return 'ابدأ اليوم!';
    if (streak == 1) return 'يوم واحد';
    if (streak <= 10) return '$streak أيام';
    return '$streak يوم';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: locator<StreakNotifier>(),
      builder: (context, streak, _) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: double.infinity,
            height: 81,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: context.tertiaryColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(icon),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(leading, style: AppTextStyles.textTheme.bodyLarge),
                    const SizedBox(height: 2),
                    Text(
                      'يتقدم بإتمام خطتك اليومية',
                      style: AppTextStyles.textTheme.labelSmall?.copyWith(
                        fontSize: 11,
                        color: AppColors.hintTextColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 1),
                Text(
                  _streakText(streak),
                  style: AppTextStyles.textTheme.bodyLarge,
                ),
                const SizedBox(width: 7),
              ],
            ),
          ),
        );
      },
    );
  }
}
