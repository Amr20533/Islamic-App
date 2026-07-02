import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/core/widgets/custom_app_bar.dart';
import 'package:islamic_app/features/onpording/presentation/cubit/onpording_image_cubit.dart';
import 'package:islamic_app/features/onpording/presentation/cubit/onpording_image_state.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:path_provider/path_provider.dart';

class ChooseAPicture extends StatelessWidget {
  const ChooseAPicture({super.key});

  static const double _size = 180;
  static const Color _borderColor = Color(0xFFD8CFC6);

  Future<String> _persistImage(File tempFile) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final saved = await tempFile.copy('${dir.path}/$fileName');
    return saved.path;
  }

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
                'اختار صورة',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),

              const SizedBox(height: 32),

              // ── Image picker circle ────────────────────────────────
              BlocBuilder<OnpordingImageCubit, OnpordingImageState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () =>
                        context.read<OnpordingImageCubit>().pickImage(),
                    child: Container(
                      width: _size,
                      height: _size,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _borderColor),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _borderColor),
                        ),
                        child: ClipOval(
                          child: state.image != null
                              ? Image.file(
                                  state.image!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Center(
                                  child: SvgPicture.asset(
                                    'assets/svg/Vector.svg',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // ── Skip button (optional) ─────────────────────────────
              TextButton(
                onPressed: () {
                  // Skip without saving image → go to gender selection
                  Navigator.pushNamed(context, AppRoutes.genderSelectionView);
                },
                child: Text(
                  'تخطي',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: AppColors.primaryColor,
                    fontSize: 18,
                  ),
                ),
              ),

              const Spacer(),

              // ── Next button: save image then navigate ──────────────
              BlocBuilder<OnpordingImageCubit, OnpordingImageState>(
                builder: (context, state) {
                  return AppPrimaryButton(
                    onPressed: () async {
                      if (state.image != null) {
                        // Persist image and save to profile
                        final savedPath = await _persistImage(state.image!);
                        if (!context.mounted) return;
                        await context.read<ProfileCubit>().updateProfileImage(
                          savedPath,
                        );
                      }
                      if (!context.mounted) return;
                      Navigator.pushNamed(
                        context,
                        AppRoutes.genderSelectionView,
                      );
                    },
                    label: 'التالي',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
