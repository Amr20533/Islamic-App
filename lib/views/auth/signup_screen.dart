import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/static_files/app_routes.dart';
import 'package:islamic_app/static_files/app_text_styles.dart';
import 'package:islamic_app/widgets/auth/auth_button.dart';
import 'package:islamic_app/widgets/default/app_primary_button.dart';
import 'package:islamic_app/widgets/default/app_text_button.dart';

import '../../static_files/app_colors.dart';
import '../../widgets/default/app_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.thirdColor,
        body: Stack(
          children: [
            // 1. THE BACKGROUND IMAGE
            Positioned.fill(
              child: Image.asset(
                'assets/icons/logo_large.png',
                fit: BoxFit.cover,
                // fit: BoxFit.fill,
              ),
            ),

            // 2. THE FRONT CONTAINER (Overlay/Gradient)
            // This adds a slight dark tint so your text/logo stands out
            // Positioned.fill(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: AppColors.thirdColor
            //     ),
            //   ),
            // ),

            // 3. THE SKIP BUTTON (Top Start)
            Positioned.directional(
              textDirection: TextDirection.rtl, // Follows your app's direction
              top: 50,    // Safe area spacing
              start: 20,  // Margin from the edge
              child: AppTextButton(onPressed: () {
                Get.offNamed(AppRoutes.main);
              },text: 'تخطي',),
            ),

            // 4. MAIN CONTENT (Login Card)
            Center(
              child: Container(
                // width: double.infinity,
                // height: 500,
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 11, vertical: 24),
                decoration: BoxDecoration(
                    color: AppColors.creamOverlay,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1, color: AppColors.authCardBorderColor)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("إنشاء حساب", style: AppTextStyles.textTheme.titleLarge!.copyWith(fontSize: 32, color: AppColors.secondaryTextColor),),
                    const SizedBox(height: 12,),
                    Text("أدخل بريدك الإلكتروني وكلمة المرور لإنشاء حساب", style: AppTextStyles.textTheme.labelMedium!.copyWith(fontSize: 12, color: AppColors.primaryColor),),
                    const SizedBox(height: 24,),
                    AppTextField(controller: TextEditingController(),hintText: 'الاسم الكامل', prefixIcon: 'user.svg',keyboardType: TextInputType.name,),
                    const SizedBox(height: 12.47,),
                    AppTextField(controller: TextEditingController(),hintText: 'البريد الإلكتروني', prefixIcon: 'email.svg',keyboardType: TextInputType.emailAddress,),
                    const SizedBox(height: 12.47,),
                    AppTextField(controller: TextEditingController(),hintText: 'كلمة المرور', prefixIcon: "lock.svg", isPassword: true,keyboardType: TextInputType.visiblePassword),
                    const SizedBox(height: 12.47,),
                    AppTextField(controller: TextEditingController(),hintText: 'تأكيد كلمة المرور', prefixIcon: "lock.svg", isPassword: true,keyboardType: TextInputType.visiblePassword),
                    const SizedBox(height: 43.63,),
                    AppPrimaryButton(onPressed: (){},label: 'إنشاء الحساب',),
                    const SizedBox(height: 24,),
                    Text("أو إنشاء حساب باستخدام", style: AppTextStyles.textTheme.labelMedium!.copyWith(fontSize: 12, color: AppColors.primaryColor),),
                    const SizedBox(height: 24,),
                    Row(
                      spacing: 15,
                      children: [
                        Expanded(
                          child: AuthButton(onPressed: (){

                          },icon: 'apple.svg'),
                        ),
                        Expanded(
                          child: AuthButton(onPressed: (){

                          },icon: 'google.svg'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 6,
                      children: [
                        Text("لديك حساب بالفعل؟", style: AppTextStyles.textTheme.labelSmall!.copyWith(fontSize: 12, color: AppColors.thinGreyColor),),
                        AppTextButton(onPressed: () {
                          Get.offNamed(AppRoutes.login);
                        },text: 'تسجيل الدخول',),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
