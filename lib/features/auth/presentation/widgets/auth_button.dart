import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class AuthButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final Color bgColor;
  final Color foregroundColor;

  const AuthButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 40,
    this.bgColor = AppColors.whiteColor,
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
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(width: 1, color: AppColors.authButtonBorderColor),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/$icon',
            allowDrawingOutsideViewBox: false,
            clipBehavior: Clip.none,
          ),
        ),
      ),
    );
  }
}
