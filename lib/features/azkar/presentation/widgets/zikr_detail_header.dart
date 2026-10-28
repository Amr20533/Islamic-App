import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/utils/app_responsive.dart';

class ZikrDetailHeader extends StatelessWidget {
  final String title;

  const ZikrDetailHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleSize = AppResponsive.fontSize(context, mobile: 18, tablet: 15, web: 16);
    final iconSize = AppResponsive.fontSize(context, mobile: 32, tablet: 28, web: 30);

    return SizedBox(
      height: 56.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFF5F2EE) : const Color(0xFF3D3020),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: isDark ? const Color(0xFFF5F2EE) : const Color(0xFF3D3020),
                size: iconSize,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
