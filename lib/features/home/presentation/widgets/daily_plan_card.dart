import 'package:flutter/material.dart';
import 'package:islamic_app/features/home/presentation/widgets/daily_plan_painter.dart';
import 'package:islamic_app/features/home/presentation/widgets/plan_item.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/static_files/app_shadows.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';

class DailyPlanCard extends StatelessWidget {
  const DailyPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: AppShadows.customShadow),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CustomPaint(
          size: const Size(342, 328),
          painter: DailyPlanPainter(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            width: 342,
            height: 328,
            alignment: AlignmentDirectional.topStart,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text('خطتك اليوم', style: AppTextStyles.textTheme.bodyLarge),
                  const SizedBox(height: 20),
                  PlanItem(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.dailyQuranPaper);
                    },
                    icon: "assets/icons/book.png",
                    title: "صفحة من القران",
                    subtitle: "3–5 دقائق",
                    isDone: true,
                  ),
                  const SizedBox(height: 18),
                  PlanItem(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.dailyDhikr);
                    },
                    icon: "assets/icons/Tasbeeh.png",
                    title: "ذكر اليوم",
                    subtitle: "15 مرة استغفر الله",
                  ),
                  const SizedBox(height: 18),
                  PlanItem(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.dailyDua);
                    },
                    icon: "assets/icons/heart.png",
                    title: "دعاء اليوم",
                    subtitle: "دعاء قصير مأثور",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
