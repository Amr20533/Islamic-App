import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class SettingsOptionRow extends StatelessWidget {
  final String? svgPath;
  final IconData? icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;
  final Color? iconColor;

  const SettingsOptionRow({
    super.key,
    this.svgPath,
    this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabelColor = labelColor ?? AppColors.primaryTextColor;
    final effectiveIconColor = iconColor ?? AppColors.counterColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (svgPath != null) ...[
                  SvgPicture.asset(
                    svgPath!,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      effectiveIconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                ] else if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: effectiveIconColor,
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: effectiveLabelColor,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.greyColor,
            ),
          ],
        ),
      ),
    );
  }
}

