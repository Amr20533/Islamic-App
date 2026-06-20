import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:islamic_app/features/profile/presentation/widgets/daily_reminder_card.dart';
import 'package:islamic_app/features/profile/presentation/widgets/profile_settings_card.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: _ProfileContent(),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // ── Header ──────────────────────────────────────────────
              const Center(
                child: Text(
                  'حسابي',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.counterColor,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Avatar + Name ────────────────────────────────────────
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final name = state is ProfileLoaded && state.profileName.isNotEmpty
                      ? state.profileName
                      : 'مستخدم';
                  final imagePath = state is ProfileLoaded
                      ? state.profileImagePath
                      : null;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.secondaryColor,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child:
                              imagePath != null && File(imagePath).existsSync()
                              ? Image.file(File(imagePath), fit: BoxFit.cover)
                              : Image.asset(
                                  'assets/images/avatar_1.jpg',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // ── Daily Reminder Card ──────────────────────────────────
              const DailyReminderCard(),

              const SizedBox(height: 24),

              // ── Settings Section Title ───────────────────────────────
              const Text(
                'الاعدادات ',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.counterColor,
                ),
              ),

              const SizedBox(height: 12),

              // ── Settings Card ────────────────────────────────────────
              const ProfileSettingsCard(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
