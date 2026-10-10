import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class BottomNavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  const BottomNavItem({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.activeColor = AppColors.primaryColor,
    this.inactiveColor = const Color(0xFF3E2F25), // Your secondaryTextColor
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentIndex == index;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveActiveColor = isDark ? theme.colorScheme.primary : activeColor;
    final effectiveInactiveColor = isDark ? const Color(0xFFB8AEA5) : inactiveColor;
    final effectiveUnselectedIconColor = isDark ? const Color(0xFFD4C8BC) : AppColors.blackColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? effectiveActiveColor : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              iconPath,
              width: 24,
              height: 24,
              cacheWidth: 800,
              color: isSelected ? AppColors.whiteColor : effectiveUnselectedIconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? effectiveActiveColor : effectiveInactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
