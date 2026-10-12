import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: isDark ? const Color(0xFFC8A88A) : context.primaryColor,
              size: 18,
            ),
          ),
          title: Text("دعاء اليوم", style: theme.textTheme.titleLarge),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 20,
                    ),
                    child: Text(
                      dailyDua,
                      style: theme.textTheme.labelSmall!.copyWith(
                        fontSize: 24,
                        height: 1.8,
                        color: isDark
                            ? const Color(0xFFF5F2EE)
                            : AppColors.primaryTextColor,
                        fontFamily: 'Tajawal',
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50, top: 16),
                child: AppPrimaryButton(
                  width: 116,
                  onPressed: () async {
                    final now = DateTime.now();
                    final dateStr = "${now.year}-${now.month}-${now.day}";
                    await locator<SharedPreferences>().setBool(
                      "daily_dua_done_$dateStr",
                      true,
                    );
                    // Increment cumulative streak if all 3 tasks done today
                    await locator<StreakNotifier>().refreshAndIncrement();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  label: 'تم',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
