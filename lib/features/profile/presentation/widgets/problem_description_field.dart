import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class ProblemDescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String hintText;
  final int minLines;
  final int maxLines;

  const ProblemDescriptionField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText = 'يرجى توضيح المشكلة التي واجهتها بالتفصيل...',
    this.minLines = 5,
    this.maxLines = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      textAlign: TextAlign.right,
      validator: validator ?? (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى كتابة وصف للمشكلة';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? const Color(0xFF242220) : Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14,
          color: isDark ? const Color(0xFFB8AEA5) : AppColors.hintTextColor,
        ),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF383430) : AppColors.borderColor2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF383430) : AppColors.borderColor2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
      ),
      style: TextStyle(
        fontFamily: 'Tajawal',
        fontSize: 15,
        color: isDark ? const Color(0xFFF5F2EE) : AppColors.primaryTextColor,
      ),
    );
  }
}
