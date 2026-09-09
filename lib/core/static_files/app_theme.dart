import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';

class AppTheme {
  // ── Light Theme (Preserves current Light Mode 100%) ────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.whiteColor,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryColor,
        onPrimary: AppColors.whiteColor,
        secondary: AppColors.secondaryColor,
        onSecondary: AppColors.whiteColor,
        tertiary: AppColors.thirdColor,
        onTertiary: AppColors.primaryTextColor,
        surface: AppColors.whiteColor,
        onSurface: AppColors.primaryTextColor,
        error: Colors.redAccent,
        onError: AppColors.whiteColor,
        outline: AppColors.greyColor,
      ),
      fontFamily: AppTextStyles.fontFamily,
      textTheme: AppTextStyles.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  // ── Dark Theme (Curated Warm Islamic Dark Palette) ─────────────────────────
  static const Color darkScaffoldBg = Color(0xFF141312);
  static const Color darkCardSurface = Color(0xFF211F1D);
  static const Color darkPrimaryAccent = Color(0xFFC8A88A);
  static const Color darkSecondaryAccent = Color(0xFFA68B70);
  static const Color darkPrimaryText = Color(0xFFF5F2EE);
  static const Color darkSecondaryText = Color(0xFFB8AEA5);
  static const Color darkBorder = Color(0xFF33302C);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: darkScaffoldBg,
      cardColor: darkCardSurface,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: darkPrimaryAccent,
        onPrimary: darkScaffoldBg,
        secondary: darkSecondaryAccent,
        onSecondary: darkScaffoldBg,
        tertiary: darkBorder,
        onTertiary: darkSecondaryText,
        surface: darkCardSurface,
        onSurface: darkPrimaryText,
        error: Colors.redAccent,
        onError: Colors.white,
        outline: darkBorder,
      ),
      fontFamily: AppTextStyles.fontFamily,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w900,
          height: 1.0,
          color: darkPrimaryAccent,
        ),
        displaySmall: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 84,
          fontWeight: FontWeight.w400,
          height: 1.0,
          color: darkPrimaryAccent,
        ),
        titleLarge: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 20,
          height: 1.0,
          fontWeight: FontWeight.w700,
          color: darkPrimaryText,
        ),
        titleSmall: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 10,
          height: 1.2,
          fontWeight: FontWeight.w400,
          color: darkSecondaryText,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.0,
          color: darkPrimaryText,
        ),
        labelMedium: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.0,
          color: darkSecondaryText,
        ),
        labelSmall: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.0,
          color: darkSecondaryText,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkScaffoldBg,
        foregroundColor: darkPrimaryText,
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
