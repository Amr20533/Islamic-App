import 'package:flutter/material.dart';
import 'package:islamic_app/features/home/presentation/widgets/daily_plan_painter.dart';
import 'package:islamic_app/features/home/presentation/widgets/plan_item.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/static_files/app_shadows.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
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
    return Container(
      decoration: BoxDecoration(boxShadow: AppShadows.customShadow),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CustomPaint(
          size: const Size(342, 310),
          painter: DailyPlanPainter(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 29),
            width: 342,
            height: 310,
            alignment: AlignmentDirectional.topStart,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('خطتك اليوم', style: AppTextStyles.textTheme.bodyLarge),
                  const SizedBox(height: 10),
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
                    title: "صفحة من القران",
                    subtitle: "3–5 دقائق",
                    isDone: _quranDone,
                  ),
                  const SizedBox(height: 18),
                  Builder(
                    builder: (context) {
                      final dhikrIndex = DailyContent.getDayOfYearIndex(
                        DailyContent.adhkhar.length,
                      );
                      final currentDhikr = DailyContent.adhkhar[dhikrIndex];
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
                  const SizedBox(height: 18),
                  PlanItem(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.dailyDua).then((
                        _,
                      ) {
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
  }
}
