import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';

class DailyQuranPaper extends StatelessWidget {
  const DailyQuranPaper({super.key});

  @override
  Widget build(BuildContext context) {
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
          title: Text(
            "صفحة من القران",
            style: AppTextStyles.textTheme.titleLarge,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "سورة البقرة - صفحة  12",
                style: AppTextStyles.textTheme.labelSmall!.copyWith(
                  fontSize: 14,
                ),
              ),
              const Spacer(flex: 1),
              AppPrimaryButton(
                width: 116,
                onPressed: () {
                  Navigator.pop(context);
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
