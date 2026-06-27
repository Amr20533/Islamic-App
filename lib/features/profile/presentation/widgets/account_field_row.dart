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
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor2, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onEdit,
                child: SvgPicture.asset('assets/svg/iconamoon_edit-thin.svg'),
              ),
            ],
          ),

          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTextColor,
            ),
          ),
          icon,
        ],
      ),
    );
  }
}
