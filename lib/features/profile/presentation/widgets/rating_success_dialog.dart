import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

void showRatingSuccessDialog(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: isDark
              ? const Color(0xFF211F1D)
              : const Color(0xFFF7F5F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDark ? const Color(0xFF383430) : AppColors.borderColor2,
              width: 1.5,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Premium Success Circle Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFFC8A88A).withValues(alpha: 0.15)
                      : AppColors.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFFC8A88A)
                        : AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.star_rounded,
                  color: isDark
                      ? const Color(0xFFC8A88A)
                      : AppColors.primaryColor,
                  size: 44,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'شكراً لك!',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? const Color(0xFFF5F2EE)
                      : AppColors.counterColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'تم إرسال تقييمك بنجاح. آرائكم تساعدنا على تقديم الأفضل دائماً.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFFB8AEA5)
                      : AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    // Pop dialog
                    Navigator.pop(dialogContext);
                    // Pop rate screen to return to profile
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? const Color(0xFFC8A88A)
                        : AppColors.primaryColor,
                    foregroundColor: isDark
                        ? const Color(0xFF141312)
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'حسناً',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
