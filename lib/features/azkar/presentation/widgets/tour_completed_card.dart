import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/daily_dhikr_cubit.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_shadows.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/core/services/streak_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TourCompletedCard extends StatelessWidget {
  const TourCompletedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 47.w, vertical: 46.h),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF282522) : context.tertiaryColor,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: isDark ? const [] : AppShadows.customShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 88.h,
            width: 88.h,
            padding: EdgeInsets.all(2.r),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1C1A) : AppColors.whiteColor,
              shape: BoxShape.circle,
              border: Border.all(
                width: 1,
                color: isDark ? const Color(0xFF383430) : AppColors.thirdTextColor,
              ),
              boxShadow: isDark ? const [] : AppShadows.softCenteredGlow,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF35312C) : AppColors.thirdColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/icons/Check.png"),
            ),
          ),
          SizedBox(height: 48.h),
          Text(
            "تمت الجولة",
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 48.h),
          AppPrimaryButton(
            onPressed: () async {
              final now = DateTime.now();
              final dateStr = "${now.year}-${now.month}-${now.day}";
              await locator<SharedPreferences>().setBool(
                "daily_dhikr_done_$dateStr",
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
          SizedBox(height: 16.h),
          AppPrimaryButton(
            onPressed: () {
              context.read<DailyDhikrCubit>().resetCount();
            },
            label: 'اعادة الجولة',
            bgColor: isDark ? const Color(0xFF383430) : AppColors.secondaryColor,
            foregroundColor: isDark ? const Color(0xFFF5F2EE) : AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
