import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class BrownCheckbox extends StatelessWidget {
  final bool isChecked;

  const BrownCheckbox({super.key, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isChecked ? AppColors.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isChecked ? AppColors.primaryColor : AppColors.borderColor,
          width: 1.5,
        ),
      ),
      child: isChecked
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )
          : null,
    );
  }
}
