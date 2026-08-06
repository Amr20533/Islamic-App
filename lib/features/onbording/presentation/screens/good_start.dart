import 'package:flutter/material.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/core/widgets/custom_app_bar.dart';

class GoodStart extends StatelessWidget {
  const GoodStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CustomAppBar(title: 'بداية طيبة', isBack: true),

              const SizedBox(height: 24),

              Image.asset("assets/images/Ellipse 90.png"),

              Text(
                "ابدأ اليوم… ولو بخطوة بسيطة",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "وَإِنَّ لِلْمُتَّقِينَ لَحُسْنَ مَآبٍ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
              const Spacer(),

              AppPrimaryButton(
                onPressed: () async {
                  final prefs = locator<SharedPreferences>();
                  await prefs.setBool('onboarding_completed', true);
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.main,
                      (route) => false,
                    );
                  }
                },
                label: 'ابدأ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
