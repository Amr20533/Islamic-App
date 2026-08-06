import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/services/helpers/islamic_occasion_helper.dart';

class IslamicOccasionCard extends StatelessWidget {
  final IslamicOccasion occasion;

  const IslamicOccasionCard({
    super.key,
    required this.occasion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: ResizeImage(
            width: 800,
            AssetImage(
            'assets/images/Gemini_Generated_Image_p06u05p06u05p06u (1) 1.png',
          ),
          ),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "المناسبة الدينية القادمة",
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.thirdTextColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              occasion.name,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.counterColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "استعد لهذه المناسبة المباركة 🌿",
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              occasion.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                height: 1.5,
                color: AppColors.hintTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
