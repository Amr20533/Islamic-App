import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class RatingCommentField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;

  const RatingCommentField({
    super.key,
    required this.controller,
    this.hintText = 'اكتب رأيك أو اقتراحاتك هنا...',
    this.minLines = 4,
    this.maxLines = 6,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14,
          color: AppColors.hintTextColor,
        ),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
      ),
      style: const TextStyle(
        fontFamily: 'Tajawal',
        fontSize: 15,
        color: AppColors.primaryTextColor,
      ),
    );
  }
}
