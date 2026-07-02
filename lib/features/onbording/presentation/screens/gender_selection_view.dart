import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/core/widgets/custom_app_bar.dart';
import 'package:islamic_app/features/onpording/presentation/cubit/selected_gender_cubit.dart';
import 'package:islamic_app/features/onpording/presentation/cubit/selected_gender_state.dart';
import 'package:islamic_app/features/onpording/presentation/widgets/gender_item.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_state.dart';

class GenderSelectionView extends StatelessWidget {
  const GenderSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CustomAppBar(title: 'معلومات بسيطة عنك', isBack: true),

              const SizedBox(height: 24),

              Text(
                'اختر جنسك',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<GenderCubit, GenderState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      GenderItem(
                        imagePath: 'assets/images/Ellipse 12.png',
                        title: 'ذكر',
                        isSelected: state.selectedGender == Gender.male,
                        onTap: () => context.read<GenderCubit>().selectGender(
                          Gender.male,
                        ),
                      ),

                      const SizedBox(height: 48),

                      GenderItem(
                        imagePath: 'assets/images/Ellipse 12 (1).png',
                        title: 'أنثى',
                        isSelected: state.selectedGender == Gender.female,
                        onTap: () => context.read<GenderCubit>().selectGender(
                          Gender.female,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const Spacer(),

              BlocBuilder<GenderCubit, GenderState>(
                builder: (context, genderState) {
                  return BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, profileState) {
                      return SizedBox(
                        width: 120,
                        child: AppPrimaryButton(
                          onPressed: () async {
                            if (genderState.selectedGender == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'من فضلك اختر جنسك أولاً',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  backgroundColor: AppColors.primaryColor,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                              return;
                            }

                            final genderStr =
                                genderState.selectedGender == Gender.male
                                ? 'male'
                                : 'female';
                            if (profileState is ProfileLoaded &&
                                profileState.profileImagePath == null) {}
                            await context.read<ProfileCubit>().updateGender(
                              genderStr,
                            );

                            if (!context.mounted) return;
                            Navigator.pushNamed(
                              context,
                              AppRoutes.birthDateView,
                            );
                          },
                          label: 'التالي',
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
