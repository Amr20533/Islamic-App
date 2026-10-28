import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/utils/app_responsive.dart';

class AdanViewHeader extends StatelessWidget {
  const AdanViewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleSize = AppResponsive.fontSize(context, mobile: 22, tablet: 18, web: 20);
    final dateSize = AppResponsive.fontSize(context, mobile: 14, tablet: 12, web: 13);
    final iconSize = AppResponsive.fontSize(context, mobile: 20, tablet: 18, web: 20);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 24.h),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark
                    ? const Color(0xFFF5F2EE)
                    : AppColors.counterColor,
                size: iconSize,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Text(
                'تنبيهات الصلاة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: titleSize,
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? const Color(0xFFC8A88A)
                      : AppColors.counterColor,
                ),
              ),
            ),
            // Placeholder to keep the title centered opposite the back button
            SizedBox(width: 48.w),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          FormatHelper.getMiladFormattedDate(),
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: dateSize,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFFB8AEA5) : AppColors.thirdTextColor,
          ),
        ),
      ],
    );
  }
}
