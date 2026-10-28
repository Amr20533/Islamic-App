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
    this.padding = 4.0,
    this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final bool isDone;
  final double padding;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final horizontalPadding = (width * 0.035).clamp(8.0, 12.0);
        final iconContainerSize = (width * 0.14).clamp(28.0, 32.0);
        // final iconSize = (iconContainerSize * 0.75).clamp(20.0, 24.0);
        final gap = (width * 0.035).clamp(8.0, 12.0);
        final radius = (width * 0.035).clamp(10.0, 12.0);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 60),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E1C1A)
                  : context.surfaceColor,
              border: Border.all(
                width: 1,
                color: isDark
                    ? const Color(0xFF383430)
                    : context.tertiaryColor,
              ),
              borderRadius: BorderRadius.circular(radius),
              boxShadow: isDark ? const [] : AppShadows.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                width: iconContainerSize,
                height: iconContainerSize,
                padding: EdgeInsets.all(padding),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFFC8A88A).withValues(alpha: 0.18)
                      : context.tertiaryColor,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  icon,
                  fit: BoxFit.contain,
                  color: isDark ? const Color(0xFFC8A88A) : null,
                ),
              ),
                SizedBox(width: gap),

                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                            fontSize: (MediaQuery.sizeOf(context).width * 0.04).clamp(10.0, 14.0),
                          color: isDark
                              ? const Color(0xFFF5F2EE)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: (MediaQuery.sizeOf(context).width * 0.027).clamp(10.0, 14.0),
                          color: isDark
                              ? const Color(0xFFB8AEA5)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),

                if (isDone) ...[
                  SizedBox(width: gap),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: (width * 0.022).clamp(6.0, 8.0),
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFFC8A88A).withValues(alpha: 0.2)
                          : context.tertiaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "تم",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isDark
                            ? const Color(0xFFC8A88A)
                            : null,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
