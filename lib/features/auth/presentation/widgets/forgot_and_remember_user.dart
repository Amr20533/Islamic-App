import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/core/widgets/app_text_button.dart';

class ForgotAndRememberUser extends StatelessWidget {
  const ForgotAndRememberUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          // spacing: 6,
          children: [
            Transform.scale(
              scale: 0.7,
              child: Checkbox(
                value: true,
                onChanged: (bool? newValue) {},

                // 1. COLORS
                activeColor: AppColors.whiteColor, // Box color when checked
                checkColor: AppColors.primaryColor, // Tick color
                // 2. THE BORDER (Use the top-level 'side' property)
                side: const BorderSide(
                  color: AppColors.hintTextColor,
                  width: 1.5,
                ),

                // 3. THE SHAPE
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.65),
                ),

                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            Text(
              "تذكرني",
              style: AppTextStyles.textTheme.labelMedium!.copyWith(
                fontSize: 12,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        AppTextButton(onPressed: () {}, text: 'نسيت كلمة السر؟'),
      ],
    );
  }
}
