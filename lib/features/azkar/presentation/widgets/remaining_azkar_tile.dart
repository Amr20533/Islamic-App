import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class RemainingAzkarTile extends StatelessWidget {
  final int index;
  final String title;
  final VoidCallback onTap;

  const RemainingAzkarTile({
    super.key,
    required this.index,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final containerBg = isDark ? const Color(0xFF242220) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF383430)
        : AppColors.borderColor.withOpacity(0.35);
    final badgeBg = isDark
        ? const Color(0xFFC8A88A).withOpacity(0.15)
        : AppColors.primaryColor.withOpacity(0.07);
    final badgeBorder = isDark
        ? const Color(0xFFC8A88A).withOpacity(0.5)
        : AppColors.primaryColor.withOpacity(0.4);
    final textColor = isDark ? const Color(0xFFF5F2EE) : AppColors.primaryTextColor;
    final arrowColor = isDark
        ? const Color(0xFFC8A88A)
        : AppColors.primaryColor.withOpacity(0.8);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: isDark
            ? const []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: isDark
              ? const Color(0xFFC8A88A).withOpacity(0.1)
              : AppColors.primaryColor.withOpacity(0.05),
          highlightColor: isDark
              ? const Color(0xFFC8A88A).withOpacity(0.05)
              : AppColors.primaryColor.withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: 45 * 3.1415926535 / 180,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: badgeBg,
                          border: Border.all(
                            color: badgeBorder,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: badgeBg,
                        border: Border.all(
                          color: badgeBorder,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Text(
                      "$index",
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: arrowColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
