import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class ZikrDetailBottomNav extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const ZikrDetailBottomNav({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavButton(
            context: context,
            icon: Icons.chevron_left,
            label: "السابق",
            onTap: onPrev,
          ),
          _buildPageIndicator(context),
          _buildNavButton(
            context: context,
            icon: Icons.chevron_right,
            label: "التالي",
            onTap: onNext,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF282522) : AppColors.lightGreyColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDark ? const Color(0xFFF5F2EE) : const Color(0xFF6B5040),
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFB8AEA5) : const Color(0xFF6B5040),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF282522) : AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        "${currentIndex + 1} / $totalPages",
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? const Color(0xFFF5F2EE) : const Color(0xFF6B5040),
        ),
      ),
    );
  }
}
