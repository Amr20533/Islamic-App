import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class AccountFieldRow extends StatelessWidget {
  final String value;
  final Widget icon;
  final VoidCallback onEdit;

  const AccountFieldRow({
    super.key,
    required this.value,
    required this.icon,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF242220)
            : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF383430) : AppColors.borderColor2,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 12),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFFF5F2EE)
                      : AppColors.primaryTextColor,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onEdit,
            child: SvgPicture.asset(
              'assets/svg/iconamoon_edit-thin.svg',
              colorFilter: ColorFilter.mode(
                isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
