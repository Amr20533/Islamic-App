import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/core/widgets/app_text_button.dart';
import 'package:islamic_app/core/widgets/app_text_field.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/features/auth/cubit/singup_cubit.dart';
import 'package:islamic_app/features/auth/cubit/singup_states.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (_) => locator<SignUpCubit>(),
        child: BlocConsumer<SignUpCubit, SignUpState>(
            listener: (context, state) {
              if (state.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account created successfully'),
                  ),
                );
              }

              // if (password != confPassword) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text("رقم المرور غير متطابق..!"),
              //     ),
              //   );
              // }

              if (state.message != null && !state.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message!),
                  ),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<SignUpCubit>();

              return Scaffold(
              backgroundColor: AppColors.thirdColor,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/icons/logo_large.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.directional(
                    textDirection: TextDirection.rtl,
                    top: 50,
                    start: 20,
                    child: AppTextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.main);
                      },
                      text: 'تخطي',
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.creamOverlay,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 1,
                            color: AppColors.authCardBorderColor,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "إنشاء حساب",
                              style: AppTextStyles.textTheme.titleLarge!.copyWith(
                                fontSize: 32,
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "أدخل بريدك الإلكتروني وكلمة المرور لإنشاء حساب",
                              style: AppTextStyles.textTheme.labelMedium!.copyWith(
                                fontSize: 12,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 24),
                            AppTextField(
                              controller: userName,
                              hintText: 'الاسم الكامل',
                              prefixIcon: 'user.svg',
                              keyboardType: TextInputType.name,
                              onChanged: context.read<SignUpCubit>().updateName,
                            ),
                            const SizedBox(height: 12.47),
                            AppTextField(
                              controller: email,
                              hintText: 'البريد الإلكتروني',
                              prefixIcon: 'email.svg',
                              keyboardType: TextInputType.emailAddress,
                              onChanged: context.read<SignUpCubit>().updateEmail,
                            ),
                            const SizedBox(height: 12.47),
                            AppTextField(
                              controller: password,
                              hintText: 'كلمة المرور',
                              prefixIcon: "lock.svg",
                              isPassword: true,
                              keyboardType: TextInputType.visiblePassword,
                              onChanged: context.read<SignUpCubit>().updatePassword,
                            ),
                            const SizedBox(height: 12.47),
                            AppTextField(
                              controller: confPassword,
                              hintText: 'تأكيد كلمة المرور',
                              prefixIcon: "lock.svg",
                              isPassword: true,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(height: 43.63),
                            AppPrimaryButton(onPressed:() {
                             if(state.isLoading){
                               return;
                             }else{
                               cubit.signUp();
                               userName.clear();
                               email.clear();
                               password.clear();
                               confPassword.clear();
                             }
                            }, label: 'إنشاء الحساب'),
                            // const SizedBox(height: 24),
                            // Text(
                            //   "أو إنشاء حساب باستخدام",
                            //   style: AppTextStyles.textTheme.labelMedium!.copyWith(
                            //     fontSize: 12,
                            //     color: AppColors.primaryColor,
                            //   ),
                            // ),
                            // const SizedBox(height: 24),
                            // Row(
                            //   spacing: 15,
                            //   children: [
                            //     Expanded(
                            //       child: AuthButton(
                            //         onPressed: () {},
                            //         icon: 'apple.svg',
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child: AuthButton(
                            //         onPressed: () {},
                            //         icon: 'google.svg',
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 6,
                              children: [
                                Text(
                                  "لديك حساب بالفعل؟",
                                  style: AppTextStyles.textTheme.labelSmall!.copyWith(
                                    fontSize: 12,
                                    color: AppColors.thinGreyColor,
                                  ),
                                ),
                                AppTextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.login,
                                    );
                                  },
                                  text: 'تسجيل الدخول',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
      );
  }
}
