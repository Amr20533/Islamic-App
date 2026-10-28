import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class AppTextStyles {
  static const String fontFamily = 'Tajawal';

  static TextTheme get textTheme => TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 32.sp,
          fontWeight: FontWeight.w900,
          height: 1.0,
          color: AppColors.thirdTextColor,
        ),

        displaySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 84.sp,
          fontWeight: FontWeight.w400,
          height: 1.0,
          color: AppColors.counterColor,
        ),

        // Section Headers
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20.sp,
          height: 1.0,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
        ),

        // Section Headers
        titleSmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 10.sp,
          height: 1.2,
          fontWeight: FontWeight.w400,
          color: AppColors.thirdTextColor,
        ),

        // Standard Body Text
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          height: 1.0,
          color: AppColors.secondaryTextColor,
        ),

        labelMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          height: 1.0,
          color: AppColors.thirdTextColor,
        ),

        labelSmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.0,
          color: AppColors.secondaryTextColor,
        ),
      );

  static TextStyle customStyle({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.secondaryTextColor,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size.sp,
      fontWeight: weight,
      color: color,
    );
  }
}
