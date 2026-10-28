import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/home/presentation/widgets/daily_plan_painter.dart';
import 'package:islamic_app/features/home/presentation/widgets/plan_item.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/static_files/app_shadows.dart';
import 'package:islamic_app/core/constants/daily_content.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyPlanCard extends StatefulWidget {
  const DailyPlanCard({super.key});

  @override
  State<DailyPlanCard> createState() => _DailyPlanCardState();
}

class _DailyPlanCardState extends State<DailyPlanCard> {
  bool _quranDone = false;
  bool _dhikrDone = false;
  bool _duaDone = false;

  @override
  void initState() {
    super.initState();
    _loadPlanStates();
  }

  void _loadPlanStates() {
    final prefs = locator<SharedPreferences>();
    final now = DateTime.now();
    final dateStr = "${now.year}-${now.month}-${now.day}";
    setState(() {
      _quranDone = prefs.getBool("daily_quran_done_$dateStr") ?? false;
      _dhikrDone = prefs.getBool("daily_dhikr_done_$dateStr") ?? false;
      _duaDone = prefs.getBool("daily_dua_done_$dateStr") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF282522) : AppColors.thirdColor;


return LayoutBuilder(
  builder: (context, constraints) {
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;

    final horizontalPadding = (width * 0.05).clamp(24.0, 24.0);
    final verticalPadding = (height * 0.06).clamp(16.0, 28.0);
    final borderRadius = (width * 0.06).clamp(18.0, 24.0);
    final titleGap = (height * 0.05).clamp(12.0, 20.0);
    final itemGap = (height * 0.045).clamp(12.0, 18.0);

    return Container(
      decoration: BoxDecoration(
        boxShadow: isDark ? const [] : AppShadows.customShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: CustomPaint(
          painter: DailyPlanPainter(backgroundColor: cardBgColor),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            alignment: AlignmentDirectional.topStart,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: itemGap-4),
                  Text(
                    'خطتك اليوم',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFFF5F2EE) : null,
                    ),
                  ),

                  SizedBox(height: titleGap),

                  PlanItem(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.dailyQuranPaper,
                      ).then((_) {
                        _loadPlanStates();
                      });
                    },
                    icon: "assets/icons/book.png",
                    padding:5,
                    title: "صفحة من القران",
                    subtitle: "3–5 دقائق",
                    isDone: _quranDone,
                  ),

                  SizedBox(height: itemGap),

                  Builder(
                    builder: (context) {
                      final dhikrIndex = DailyContent.getDayOfYearIndex(
                        DailyContent.adhkhar.length,
                      );
                      final currentDhikr =
                          DailyContent.adhkhar[dhikrIndex];

                      return PlanItem(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.dailyDhikr,
                          ).then((_) {
                            _loadPlanStates();
                          });
                        },
                        icon: "assets/icons/Tasbeeh.png",
                        title: "ذكر اليوم",
                        subtitle: currentDhikr['subtitle'] as String,
                        isDone: _dhikrDone,
                      );
                    },
                  ),

                  SizedBox(height: itemGap),

                  PlanItem(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.dailyDua,
                      ).then((_) {
                        _loadPlanStates();
                      });
                    },
                    icon: "assets/icons/heart.png",
                    title: "دعاء اليوم",
                    subtitle: "دعاء قصير مأثور",
                    isDone: _duaDone,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  },
);
  }
}
