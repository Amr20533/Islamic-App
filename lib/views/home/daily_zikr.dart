import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/core/controllers/daily_dhikr_controller.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/services/extensions/theme_extension.dart';
import 'package:islamic_app/services/helpers/format_helper.dart';
import 'package:islamic_app/static_files/app_colors.dart';
import 'package:islamic_app/static_files/app_text_styles.dart';
import 'package:islamic_app/widgets/home/tour_completed_card.dart';

class DailyZikr extends StatelessWidget {
  const DailyZikr({super.key});

  @override
  Widget build(BuildContext context) {
    final DailyDhikrController dailyDhikrController = locator<DailyDhikrController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightGreyColor,
        appBar: AppBar(
          backgroundColor: AppColors.lightGreyColor,
          leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_sharp, color: context.primaryColor, size: 18,),
          ),
          title: Text("ذكر اليوم", style: AppTextStyles.textTheme.titleLarge,),
        ),
        body: // Use SizedBox.expand so the Stack knows the full screen boundaries
        SizedBox.expand(
          child: Stack(
            children: [
              // 1. MAIN CONTENT (Centered Dhikr Counter)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\"استغفر الله\"",
                      style: AppTextStyles.textTheme.displayLarge,
                    ),
                    Obx(() => GestureDetector(
                      onTap: () => dailyDhikrController.incrementCount(),
                      child: Container(
                        width: 271,
                        height: 271,
                        margin: const EdgeInsets.only(top: 77, bottom: 41),
                        decoration: BoxDecoration(
                          color: context.tertiaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: AppColors.lightGreyColor),
                          boxShadow: context.softShadow, // Added your shadow here too!
                        ),
                        child: Center(
                          child: Text("${dailyDhikrController.count.value} / ${dailyDhikrController.maxCount}",
                            style: AppTextStyles.textTheme.displaySmall?.copyWith(height: 1),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // child: Center(
                        //   child: Text(
                        //     FormatHelper.replaceWithArabicNumbers(
                        //         "${dailyDhikrController.count.value} / ${dailyDhikrController.maxCount}"
                        //     ),
                        //     style: AppTextStyles.textTheme.displaySmall?.copyWith(height: 1),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                      ),
                    ),
                    ),
                    Text(
                      "اضغط للعد",
                      style: AppTextStyles.textTheme.labelSmall?.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Obx(() {
                if (dailyDhikrController.isCompleted) {
                  return Align(
                    alignment: Alignment.center,
                    child: TourCompletedCard(),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

