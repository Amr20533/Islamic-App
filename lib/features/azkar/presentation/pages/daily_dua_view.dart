import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/core/constants/daily_content.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/core/services/streak_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyDuaView extends StatelessWidget {
  const DailyDuaView({super.key});

  @override
  Widget build(BuildContext context) {
    final index = DailyContent.getDayOfYearIndex(DailyContent.duas.length);
    final dailyDua = DailyContent.duas[index];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightGreyColor,
        appBar: AppBar(
          backgroundColor: AppColors.lightGreyColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: context.primaryColor,
              size: 18,
            ),
          ),
          title: Text("دعاء اليوم", style: AppTextStyles.textTheme.titleLarge),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Text(
                  dailyDua,
                  style: AppTextStyles.textTheme.labelSmall!.copyWith(
                    fontSize: 24,
                    height: 1.6,
                    color: AppColors.primaryTextColor,
                    fontFamily: 'Tajawal',
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const Spacer(flex: 1),
              AppPrimaryButton(
                width: 116,
                onPressed: () async {
                  final now = DateTime.now();
                  final dateStr = "${now.year}-${now.month}-${now.day}";
                  await locator<SharedPreferences>().setBool(
                    "daily_dua_done_$dateStr",
                    true,
                  );
                  // Auto-refresh the streak card on home screen
                  locator<StreakNotifier>().refresh();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                label: 'تم',
              ),
              const SizedBox(height: 37),
            ],
          ),
        ),
      ),
    );
  }
}
