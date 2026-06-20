import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

/// A single prayer row in the alarm settings screen.
/// Mirrors the visual style of [_PrayerRow] in [PrayerTimesCard]
/// and adds an [Switch] to enable/disable the alarm.
class PrayerAlarmRow extends StatelessWidget {
  final String name;
  final DateTime? time;
  final String iconPath;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  const PrayerAlarmRow({
    super.key,
    required this.name,
    required this.time,
    required this.iconPath,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isPng = iconPath.endsWith('.png');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Prayer icon + name
          Row(
            children: [
              if (isPng)
                Image.asset(iconPath, width: 32, height: 32)
              else
                SvgPicture.asset(iconPath, width: 24, height: 24),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.counterColor,
                ),
              ),
            ],
          ),
          // Time + toggle
          Row(
            children: [
              Text(
                FormatHelper.formatTime12Hour(time),
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.thirdTextColor,
                ),
              ),
              const SizedBox(width: 8),
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: isEnabled,
                  onChanged: onToggle,
                  activeThumbColor: AppColors.primaryColor,
                  activeTrackColor: AppColors.secondaryColor,
                  inactiveThumbColor: AppColors.greyColor,
                  inactiveTrackColor: AppColors.lightGreyColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
