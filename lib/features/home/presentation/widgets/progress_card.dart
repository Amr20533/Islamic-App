import 'package:flutter/material.dart';
import 'package:islamic_app/core/utils/app_responsive.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/services/streak_notifier.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final horizontalPadding = (width * 0.045).clamp(10.0, 16.0);
        final verticalPadding = (width * 0.035).clamp(9.0, 13.0);
        final iconSize = (width * 0.15).clamp(40.0, 54.0);
        final gap = (width * 0.03).clamp(8.0, 12.0);
        final gap16 = (width * 0.04).clamp(10.0, 16.0);
        final radius = (width * 0.065).clamp(18.0, 24.0);

        return ValueListenableBuilder<int>(
          valueListenable: locator<StreakNotifier>(),
          builder: (context, streak, _) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF282522)
                      : context.tertiaryColor,
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Row(
                  children: [
                    // ── Icon ───────────────────────────────────────────────────
                    Container(
                      width: iconSize,
                      height: iconSize,
                      padding: EdgeInsets.all(iconSize * 0.12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E1D1B)
                            : context.surfaceColor,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        icon,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: gap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            leading,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppResponsive.bodyStyle(
                              context,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFF5F2EE) : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'يتقدم بإتمام خطتك اليومية',
                            style: AppResponsive.labelStyle(
                              context,
                              color: isDark
                                  ? const Color(0xFFB8AEA5)
                                  : AppColors.hintTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: gap),
                    Flexible(
                      flex: 0,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _streakText(streak),
                          style: AppResponsive.bodyStyle(
                            context,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFC8A88A) : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: gap16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
