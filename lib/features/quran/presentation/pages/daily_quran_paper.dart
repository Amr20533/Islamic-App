import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/features/quran/data/models/quran_metadata.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/features/quran/presentation/widgets/mushaf_page_widget.dart';

class DailyQuranPaper extends StatefulWidget {
  const DailyQuranPaper({super.key});

  @override
  State<DailyQuranPaper> createState() => _DailyQuranPaperState();
}

class _DailyQuranPaperState extends State<DailyQuranPaper> {
  late int _dailyPageNumber;
  late String _surahName;
  bool _isInit = false;

  /// Calculate today's page number (1-604) based on the day of the year.
  /// Each day shows a different page, cycling through all 604 pages.
  int _getDailyPageNumber() {
    final now = DateTime.now();
    // Reference date: start of the current year
    final startOfYear = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(startOfYear).inDays;
    // Pages 1-604, cycling every 604 days
    return (dayOfYear % 604) + 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _dailyPageNumber = _getDailyPageNumber();

      // Get surah info for this page
      final metadata = QuranMetadata.pageToSurah[_dailyPageNumber];
      final surahNumber = metadata?['surahNumber'] as int? ?? 1;
      _surahName = metadata?['surahName'] as String? ?? 'الفاتحة';

      // Load the surah data via the existing QuranCubit
      context.read<QuranCubit>().loadSurahData(surahNumber);

      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBF9F1),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFBF9F1),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: context.primaryColor,
              size: 18,
            ),
          ),
          title: Text(
            "صفحة من القرآن",
            style: AppTextStyles.textTheme.titleLarge,
          ),
        ),
        body: Column(
          children: [
            // Page info header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "سورة $_surahName",
                    style: AppTextStyles.textTheme.labelMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "صفحة $_dailyPageNumber",
                      style: AppTextStyles.textTheme.labelSmall?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Quran page content
            Expanded(
              child: BlocBuilder<QuranCubit, QuranState>(
                builder: (context, state) {
                  if (state is QuranLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  if (state is QuranLoaded) {
                    final verses = state.pages[_dailyPageNumber];
                    if (verses == null || verses.isEmpty) {
                      return Center(
                        child: Text(
                          "جارٍ تحميل الصفحة...",
                          style: AppTextStyles.textTheme.labelMedium,
                        ),
                      );
                    }

                    return MushafPageWidget(
                      verses: verses,
                      pageNumber: _dailyPageNumber,
                    );
                  }

                  if (state is QuranError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "حدث خطأ أثناء تحميل الصفحة",
                            style: AppTextStyles.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                },
              ),
            ),

            // Done button at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 37, top: 12),
              child: AppPrimaryButton(
                width: 116,
                onPressed: () {
                  Navigator.pop(context);
                },
                label: 'تم',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
