import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class AdanViewHeader extends StatelessWidget {
  const AdanViewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.counterColor,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            const Expanded(
              child: Text(
                'تنبيهات الصلاة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.counterColor,
                ),
              ),
            ),
            // Balances the back button so the title stays centred
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          FormatHelper.getMiladFormattedDate(),
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.thirdTextColor,
          ),
        ),
      ],
    );
  }
}
