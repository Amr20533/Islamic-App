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
              color: isSelected ? activeColor : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              iconPath,
              width: 24,
              height: 24,
              cacheWidth: 800,
              color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
