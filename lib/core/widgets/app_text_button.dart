import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;

  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.secondaryColor,
      ),
      child: Text(
        text,
        style: AppTextStyles.textTheme.labelMedium!.copyWith(
          fontSize: fontSize,
          color: color ?? AppColors.primaryColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
