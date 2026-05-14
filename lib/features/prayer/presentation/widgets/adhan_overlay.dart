import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/adhan_bloc.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/adhan_event.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';

class AdhanOverlay extends StatelessWidget {
  final String prayerName;
  const AdhanOverlay({super.key, required this.prayerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [Color(0xFF8B6B4F), Color(0xFF3E2F25)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mosque, size: 100, color: AppColors.whiteColor),
            const SizedBox(height: 30),
            Text(
              "حان الآن موعد أذان $prayerName",
              style: AppTextStyles.textTheme.bodyLarge!.copyWith(
                fontSize: 28,
                color: AppColors.creamOverlay,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "حي على الصلاة.. حي على الفلاح",
              style: AppTextStyles.textTheme.titleSmall!.copyWith(
                fontSize: 18,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(height: 60),
            AppPrimaryButton(
              width: 240,
              label: "إيقاف الأذان",
              onPressed: () {
                context.read<AdhanBloc>().add(AdhanStopEvent());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
