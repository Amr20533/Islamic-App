import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class ProblemTypeDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;

  const ProblemTypeDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.hintText = 'اختر نوع المشكلة',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedValue,
      hint: Text(
        hintText,
        style: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14,
          color: AppColors.hintTextColor,
        ),
      ),
      items: items.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(
            type,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15,
              color: AppColors.primaryTextColor,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
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
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.primaryColor,
      ),
      dropdownColor: Colors.white,
    );
  }
}
