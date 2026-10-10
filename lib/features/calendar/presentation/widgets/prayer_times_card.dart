import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/widgets/custom_asset_image.dart';

class PrayerTimesCard extends StatelessWidget {
  final Map<String, DateTime?> todayPrayers;

  const PrayerTimesCard({super.key, required this.todayPrayers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final dividerColor = isDark ? const Color(0xFF383430) : AppColors.borderColor;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242220) : null,
        borderRadius: BorderRadius.circular(10),
        border: isDark
            ? Border.all(color: const Color(0xFF383430), width: 1)
            : null,
        image: DecorationImage(
          image: const ResizeImage(
            width: 800,
            AssetImage(
              'assets/images/Gemini_Generated_Image_1vp5pk1vp5pk1vp5 (1) 1.png',
            ),
          ),
          fit: BoxFit.cover,
          colorFilter: isDark
              ? ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.75),
                  BlendMode.darken,
                )
              : null,
        ),
        boxShadow: isDark
            ? const []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "أوقات الصلاة",
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFC8A88A) : AppColors.counterColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.alarms);
                  },
                  child: SvgPicture.asset(
                    "assets/svg/proicons_bell.svg",
                    width: 24,
                    height: 24,
                    colorFilter: isDark
                        ? const ColorFilter.mode(
                            Color(0xFFC8A88A),
                            BlendMode.srcIn,
                          )
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _PrayerRow(
              name: "الفجر",
              time: todayPrayers["الفجر"],
              iconPath: "assets/images/fajr.png",
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: dividerColor,
            ),
            _PrayerRow(
              name: "الشروق",
              time: todayPrayers["الشروق"],
              iconPath: "assets/images/sunrise.png",
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: dividerColor,
            ),
            _PrayerRow(
              name: "الظهر",
              time: todayPrayers["الظهر"],
              iconPath: "assets/images/dhuhr.png",
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: dividerColor,
            ),
            _PrayerRow(
              name: "العصر",
              time: todayPrayers["العصر"],
              iconPath: "assets/images/asr.png",
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: dividerColor,
            ),
            _PrayerRow(
              name: "المغرب",
              time: todayPrayers["المغرب"],
              iconPath: "assets/images/maghrib.png",
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: dividerColor,
            ),
            _PrayerRow(
              name: "العشاء",
              time: todayPrayers["العشاء"],
              iconPath: "assets/images/isha.png",
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  final String name;
  final DateTime? time;
  final String iconPath;

  const _PrayerRow({
    required this.name,
    required this.time,
    required this.iconPath,
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
          Row(
            children: [
              if (isPng)
                CustomAssetImage(image: iconPath, width: 32, height: 32)
              else
                SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    isDark ? const Color(0xFFC8A88A) : Colors.grey,
                    BlendMode.srcIn,
                  ),
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
          Text(
            FormatHelper.formatTime12Hour(time),
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFF5F2EE) : AppColors.counterColor,
            ),
          ),
        ],
      ),
    );
  }
}
