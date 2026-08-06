import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/core/widgets/app_text_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBack;
  final VoidCallback? onBackPressed;
  final String? skipText;
  final VoidCallback? onSkipPressed;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.isBack = true,
    this.onBackPressed,
    this.skipText,
    this.onSkipPressed,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      color: backgroundColor,
      child: SafeArea(
        bottom: true,
        child: SizedBox(
          height: preferredSize.height,
          child: Row(
            children: [
              if (isBack)
                Semantics(
                  label: 'Back',
                  button: true,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    onPressed:
                        onBackPressed ?? () => Navigator.maybePop(context),
                  ),
                )
              else
                const SizedBox(width: 48),

              // العنوان في المنتصف
              Expanded(
                child: Text(
                  title,
                  style:
                      AppTextStyles.textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ) ??
                      const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),

              // زر التخطي على الطرف الآخر (أو مساحة فارغة للتوازن)
              if (skipText != null)
                AppTextButton(
                  text: skipText!,
                  onPressed: onSkipPressed ?? () {},
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
