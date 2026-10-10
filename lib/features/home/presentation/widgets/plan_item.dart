import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_shadows.dart';

class PlanItem extends StatelessWidget {
  const PlanItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isDone = false,
    this.onTap,
  });
  final String icon;
  final String title;
  final String subtitle;
  final bool isDone;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1C1A) : context.surfaceColor,
          border: Border.all(
            width: 1,
            color: isDark ? const Color(0xFF383430) : context.tertiaryColor,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isDark ? const [] : AppShadows.cardShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFFC8A88A).withOpacity(0.18)
                    : context.tertiaryColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                icon,
                width: 18,
                height: 18,
                color: isDark ? const Color(0xFFC8A88A) : null,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFF5F2EE) : null,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isDark ? const Color(0xFFB8AEA5) : null,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 1),
            if (isDone)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFFC8A88A).withOpacity(0.2)
                      : context.tertiaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "تم",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isDark ? const Color(0xFFC8A88A) : null,
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
