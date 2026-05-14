import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.icon,
    required this.leading,
    required this.trailing,
  });
  final String icon;
  final String leading;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        height: 81,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: context.tertiaryColor,
          // border: Border.all(width: 1, color: context.tertiaryColor),
          borderRadius: BorderRadius.circular(24),
          // boxShadow: AppShadows.cardShadow
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: context.surfaceColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(icon),
            ),
            Text(leading, style: AppTextStyles.textTheme.bodyLarge),
            Spacer(flex: 1),
            Text(trailing, style: AppTextStyles.textTheme.bodyLarge),
            const SizedBox(width: 7),
          ],
        ),
      ),
    );
  }
}
