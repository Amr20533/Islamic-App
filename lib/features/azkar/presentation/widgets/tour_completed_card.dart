import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/daily_dhikr_cubit.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_shadows.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/core/services/streak_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TourCompletedCard extends StatelessWidget {
  const TourCompletedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.symmetric(horizontal: 47, vertical: 46),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.tertiaryColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: AppShadows.customShadow,
      ),
      child: Column(
        children: [
          Container(
            height: 88,
            width: 88,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: AppColors.thirdTextColor),
              boxShadow: AppShadows.softCenteredGlow,
            ),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.thirdColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/icons/Check.png"),
            ),
          ),
          const SizedBox(height: 64),
          Text("تمت الجولة", style: AppTextStyles.textTheme.titleLarge),
          const SizedBox(height: 64),
          AppPrimaryButton(
            onPressed: () async {
              final now = DateTime.now();
              final dateStr = "${now.year}-${now.month}-${now.day}";
              await locator<SharedPreferences>().setBool(
                "daily_dhikr_done_$dateStr",
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
          const SizedBox(height: 16),
          AppPrimaryButton(
            onPressed: () {
              context.read<DailyDhikrCubit>().resetCount();
            },
            label: 'اعادة الجولة',
            bgColor: AppColors.secondaryColor,
            foregroundColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
