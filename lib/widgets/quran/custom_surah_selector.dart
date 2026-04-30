import 'package:flutter/material.dart';
import 'package:islamic_app/core/controllers/quran/surah_selection_controller.dart';
import 'package:islamic_app/static_files/app_colors.dart';
import 'package:islamic_app/static_files/app_text_styles.dart';

import 'package:get/get.dart';

import '../../di/locator.dart';

class CustomSurahSelector extends StatelessWidget {
  const CustomSurahSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // Locating the controller
    final SurahSelectorController controller = locator<SurahSelectorController>();

    return Container(
      height: 32,
      alignment: Alignment.center,
      child: Row(
        spacing: 8,
        children: List.generate(controller.categories.length, (index) {
          // Obx wraps only the parts that need to change
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.updateIndex(index),
              child: Obx(() {
                bool isSelected = index == controller.selectedIndex;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        width: 1,
                        color: isSelected ? Colors.transparent : AppColors.borderColor,
                      )
                  ),
                  child: Text(
                    controller.categories[index],
                    style: (AppTextStyles.textTheme.titleMedium ?? const TextStyle()).copyWith(
                      fontSize: 16,
                      color: isSelected ? AppColors.whiteColor : AppColors.primaryColor,
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}