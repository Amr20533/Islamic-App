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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  colorFilter: isDark
                      ? const ColorFilter.mode(
                          Color(0xFFC8A88A),
                          BlendMode.srcIn,
                        )
                      : null,
                ),
              const SizedBox(width: 8),
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFF5F2EE) : AppColors.counterColor,
                ),
              ),
            ],
          ),
          // Time + toggle
          Row(
            children: [
              Text(
                FormatHelper.formatTime12Hour(time),
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFFB8AEA5) : AppColors.thirdTextColor,
                ),
              ),
              const SizedBox(width: 8),
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: isEnabled,
                  onChanged: onToggle,
                  activeThumbColor: isDark ? const Color(0xFF141312) : Colors.white,
                  activeTrackColor: isDark ? const Color(0xFFC8A88A) : AppColors.secondaryColor,
                  inactiveThumbColor: isDark ? const Color(0xFFB8AEA5) : AppColors.greyColor,
                  inactiveTrackColor: isDark ? const Color(0xFF383430) : AppColors.lightGreyColor,
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
