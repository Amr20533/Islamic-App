import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/core/controllers/daily_dhikr_controller.dart' show DailyDhikrController;
import 'package:islamic_app/services/extensions/theme_extension.dart';
import 'package:islamic_app/static_files/app_colors.dart';
import 'package:islamic_app/static_files/app_shadows.dart';
import 'package:islamic_app/static_files/app_text_styles.dart';
import 'package:islamic_app/widgets/default/app_primary_button.dart';

import '../../di/locator.dart';

class TourCompletedCard extends StatelessWidget {
  const TourCompletedCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DailyDhikrController dailyDhikrController = locator<DailyDhikrController>();

    return Container(
      height: 500,
      padding: const EdgeInsets.symmetric(horizontal: 47, vertical: 46),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.tertiaryColor,
        borderRadius: BorderRadius.circular(32),
          boxShadow: AppShadows.customShadow
      ),
      child: Column(
        children: [
          Container(
            height: 88,
            width: 88,
            padding: EdgeInsets.all(2),
            // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: AppColors.thirdTextColor),
                boxShadow: AppShadows.softCenteredGlow
            ),
            child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.thirdColor,
                  shape: BoxShape.circle,
                ),
                child: Image.asset("assets/icons/Check.png")),
          ),
          const SizedBox(height: 64),
          Text(
            "تمت الجولة",
            style: AppTextStyles.textTheme.titleLarge,
          ),
          const SizedBox(height: 64),
          AppPrimaryButton(
            onPressed: () {
              Get.back();
            },
            label: 'تم',
          ),
          const SizedBox(height: 16),
          AppPrimaryButton(
            onPressed: () {
              dailyDhikrController.resetCount();
            },
            label: 'اعادة الجولة',
            bgColor: AppColors.secondaryColor,
            foregroundColor: AppColors.primaryColor,
          )


        ],
      ),
    );
  }
}
