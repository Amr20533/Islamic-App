import 'package:flutter/material.dart';
import 'package:islamic_app/services/extensions/theme_extension.dart';
import 'package:islamic_app/static_files/app_shadows.dart';
import 'package:islamic_app/static_files/app_text_styles.dart';

class PlanItem extends StatelessWidget {
  const PlanItem({
    super.key, required this.icon, required this.title, required this.subtitle, this.isDone = false, this.onTap,
  });
  final String icon;
  final String title;
  final String subtitle;
  final bool isDone;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: context.surfaceColor,
            border: Border.all(width: 1, color: context.tertiaryColor),
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppShadows.cardShadow
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: context.tertiaryColor,
                  shape: BoxShape.circle
              ),
              child: Image.asset(icon),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing:5,
              children: [
                Text(title, style: AppTextStyles.textTheme.labelSmall,),
                Text(subtitle, style: AppTextStyles.textTheme.titleSmall,),
              ],
            ),
            Spacer(flex: 1,),
            isDone ? Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: context.tertiaryColor,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Text("تم", style: AppTextStyles.textTheme.titleSmall,),
            ) : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}