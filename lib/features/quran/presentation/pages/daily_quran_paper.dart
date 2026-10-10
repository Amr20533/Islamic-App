import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/features/quran/data/models/quran_metadata.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/features/quran/presentation/widgets/mushaf_page_widget.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/core/services/streak_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key used to store the last Quran page the user read (1-604).
const _kLastQuranPage = 'quran_sequential_last_page';

class DailyQuranPaper extends StatefulWidget {
  const DailyQuranPaper({super.key});

  @override
  State<DailyQuranPaper> createState() => _DailyQuranPaperState();
}

class _DailyQuranPaperState extends State<DailyQuranPaper> {
  late int _pageNumber;
  late String _surahName;
  bool _isInit = false;

  /// Returns the next page after the last read page.
  /// Picks up exactly where the user left off, cycling after page 604.
  int _getSequentialPage() {
    final prefs = locator<SharedPreferences>();
    final lastPage = prefs.getInt(_kLastQuranPage) ?? 0;
    // Next page after last read, cycling 1-604
    return (lastPage % 604) + 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _pageNumber = _getSequentialPage();

      // Get surah info for this page
      final metadata = QuranMetadata.pageToSurah[_pageNumber];
      final surahNumber = metadata?['surahNumber'] as int? ?? 1;
      _surahName = metadata?['surahName'] as String? ?? 'الفاتحة';

      // Load the surah data via the existing QuranCubit
      context.read<QuranCubit>().loadSurahData(surahNumber);

      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: isDark ? const Color(0xFFF5F2EE) : context.primaryColor,
              size: 18,
            ),
          ),
          title: Text(
            "صفحة من القرآن",
            style: (AppTextStyles.textTheme.titleLarge ?? const TextStyle()).copyWith(
              color: isDark ? const Color(0xFFC8A88A) : null,
            ),
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
                    style: (AppTextStyles.textTheme.labelMedium ?? const TextStyle()).copyWith(
                      color: isDark ? const Color(0xFFF5F2EE) : AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFFC8A88A).withValues(alpha: 0.18)
                          : AppColors.primaryColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "صفحة $_pageNumber من 604",
                      style: (AppTextStyles.textTheme.labelSmall ?? const TextStyle()).copyWith(
                        color: isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor,
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
                    final verses = state.pages[_pageNumber];
                    if (verses == null || verses.isEmpty) {
                      final metadata = QuranMetadata.pageToSurah[_pageNumber];
                      if (metadata != null) {
                        final surahNumber = metadata['surahNumber'] as int;
                        context.read<QuranCubit>().loadSurahIfNeeded(surahNumber);
                      }
                      return Center(
                        child: Text(
                          "جارٍ تحميل الصفحة...",
                          style: AppTextStyles.textTheme.labelMedium,
                        ),
                      );
                    }

                    return MushafPageWidget(
                      verses: verses,
                      pageNumber: _pageNumber,
                      bottomPadding: 20.0,
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
                onPressed: () async {
                  final prefs = locator<SharedPreferences>();

                  // ① Save the page just read as the new sequential bookmark
                  await prefs.setInt(_kLastQuranPage, _pageNumber);

                  // ② Mark today's Quran task as done
                  final now = DateTime.now();
                  final dateStr = "${now.year}-${now.month}-${now.day}";
                  await prefs.setBool("daily_quran_done_$dateStr", true);

                  // ③ Try to increment the cumulative streak if all 3 tasks are done today
                  await locator<StreakNotifier>().refreshAndIncrement();

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
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

