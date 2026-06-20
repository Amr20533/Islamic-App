import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';

class PrayerTimesCard extends StatelessWidget {
  final Map<String, DateTime?> todayPrayers;

  const PrayerTimesCard({super.key, required this.todayPrayers});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage(
            'assets/images/Gemini_Generated_Image_1vp5pk1vp5pk1vp5 (1) 1.png',
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
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
                const Text(
                  "أوقات الصلاة",
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.counterColor,
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
            const Divider(
              height: 1,
              thickness: 0.5,
              color: AppColors.borderColor,
            ),
            _PrayerRow(
              name: "الشروق",
              time: todayPrayers["الشروق"],
              iconPath: "assets/images/sunrise.png",
            ),
            const Divider(
              height: 1,
              thickness: 0.5,
              color: AppColors.borderColor,
            ),
            _PrayerRow(
              name: "الظهر",
              time: todayPrayers["الظهر"],
              iconPath: "assets/images/dhuhr.png",
            ),
            const Divider(
              height: 1,
              thickness: 0.5,
              color: AppColors.borderColor,
            ),
            _PrayerRow(
              name: "العصر",
              time: todayPrayers["العصر"],
              iconPath: "assets/images/asr.png",
            ),
            const Divider(
              height: 1,
              thickness: 0.5,
              color: AppColors.borderColor,
            ),
            _PrayerRow(
              name: "المغرب",
              time: todayPrayers["المغرب"],
              iconPath: "assets/images/maghrib.png",
            ),
            const Divider(
              height: 1,
              thickness: 0.5,
              color: AppColors.borderColor,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          Text(
            FormatHelper.formatTime12Hour(time),
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.counterColor,
            ),
          ),
        ],
      ),
    );
  }
}
