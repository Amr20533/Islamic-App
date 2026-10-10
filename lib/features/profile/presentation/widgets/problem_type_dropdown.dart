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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonFormField<String>(
      // initialValue: selectedValue,
      hint: Text(
        hintText,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14,
          color: isDark ? const Color(0xFFB8AEA5) : AppColors.hintTextColor,
        ),
      ),
      items: items.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(
            type,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15,
              color: isDark
                  ? const Color(0xFFF5F2EE)
                  : AppColors.primaryTextColor,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? const Color(0xFF242220) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
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
      ),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor,
      ),
      dropdownColor: isDark ? const Color(0xFF211F1D) : Colors.white,
    );
  }
}
