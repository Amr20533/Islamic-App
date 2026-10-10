import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class BrownCheckbox extends StatelessWidget {
  final bool isChecked;

  const BrownCheckbox({super.key, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isChecked
            ? (isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor)
            : (isDark ? const Color(0xFF1E1C1A) : Colors.white),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isChecked
              ? (isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor)
              : (isDark ? const Color(0xFF383430) : AppColors.borderColor),
          width: 1.5,
        ),
      ),
      child: isChecked
          ? Icon(
              Icons.check,
              color: isDark ? const Color(0xFF141312) : Colors.white,
              size: 16,
            )
          : null,
    );
  }
}
