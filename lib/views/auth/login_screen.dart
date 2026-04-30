import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/static_files/app_colors.dart';
import 'package:islamic_app/static_files/app_text_styles.dart';
import 'package:islamic_app/widgets/auth/auth_button.dart';
import 'package:islamic_app/widgets/auth/forgot_and_remember_user.dart';
import 'package:islamic_app/widgets/default/app_primary_button.dart';
import '../../static_files/app_routes.dart';
import '../../widgets/default/app_text_button.dart';
import '../../widgets/default/app_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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

            // 3. THE SKIP BUTTON (Top Start)
            Positioned.directional(
              textDirection: TextDirection.rtl,
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
                    Text("تسجيل الدخول", style: AppTextStyles.textTheme.titleLarge!.copyWith(fontSize: 32, color: AppColors.secondaryTextColor),),
                    const SizedBox(height: 12,),
                    Text("أدخل بريدك الإلكتروني وكلمة المرور لتسجيل الدخول", style: AppTextStyles.textTheme.labelMedium!.copyWith(fontSize: 12, color: AppColors.primaryColor),),
                    const SizedBox(height: 24,),
                    AppTextField(controller: TextEditingController(),hintText: 'البريد الإلكتروني', prefixIcon: 'email.svg',),
                    const SizedBox(height: 12.47,),
                    AppTextField(controller: TextEditingController(),hintText: 'كلمة المرور', prefixIcon: "lock.svg", isPassword: true,),
                    const SizedBox(height: 6.23,),
                    ForgotAndRememberUser(),
                    const SizedBox(height: 43.5,),
                    AppPrimaryButton(onPressed: (){},label: 'دخول',),
                    const SizedBox(height: 24,),
                    Text("أو سجّل الدخول باستخدام", style: AppTextStyles.textTheme.labelMedium!.copyWith(fontSize: 12, color: AppColors.primaryColor),),
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
                        Text("ليس لديك حساب؟", style: AppTextStyles.textTheme.labelSmall!.copyWith(fontSize: 12, color: AppColors.thinGreyColor),),
                        AppTextButton(onPressed: () {
                          Get.offNamed(AppRoutes.signup);
                        },text: 'أنشئ حسابًا',),
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

