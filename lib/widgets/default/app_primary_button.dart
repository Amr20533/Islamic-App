import 'package:flutter/material.dart';
import 'package:islamic_app/services/extensions/theme_extension.dart';
import 'package:islamic_app/static_files/app_colors.dart';
import 'package:islamic_app/static_files/app_text_styles.dart';

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final double fontSize;
  final double radius;
  final Color bgColor;
  final Color foregroundColor;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 40,
    this.radius = 12.47,
    this.fontSize = 16,
    this.bgColor = AppColors.primaryColor,
    this.foregroundColor = AppColors.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: foregroundColor,
          // foregroundColor: context.surfaceColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: AppTextStyles.textTheme.titleLarge?.copyWith(
            color: context.surfaceColor,
            fontSize: fontSize,
            height: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}