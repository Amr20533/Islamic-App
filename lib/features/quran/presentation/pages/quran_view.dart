import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/features/quran/presentation/bloc/surah_selector_cubit.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/features/quran/presentation/widgets/custom_surah_selector.dart';

/// Helper to communicate reading progress updates in real-time across widgets.
class QuranLastReadHelper {
  static final ValueNotifier<({String surahName, int pageNumber})?> lastReadNotifier =
      ValueNotifier(null);

  static void update(String surahName, int pageNumber) {
    lastReadNotifier.value = (surahName: surahName, pageNumber: pageNumber);
  }
}

class QuranView extends StatefulWidget {
  const QuranView({super.key});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  @override
  void initState() {
    super.initState();
    _initLastRead();
  }

  void _initLastRead() {
    final prefs = locator<SharedPreferences>();
    final surahName = prefs.getString('last_read_surah_name');
    final pageNumber = prefs.getInt('last_read_page_number');

    if (surahName != null && pageNumber != null) {
      QuranLastReadHelper.lastReadNotifier.value = (
        surahName: surahName,
        pageNumber: pageNumber,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightGreyColor,
        appBar: AppBar(
          backgroundColor: AppColors.lightGreyColor,
          leading: Container(),
          title: Text("القران", style: AppTextStyles.textTheme.titleLarge),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 24),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.bookmark);
                },
                child: Image.asset(
                  "assets/icons/Vector (9).png",
                  width: 18,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              spacing: 20,
              children: [
                ValueListenableBuilder<({String surahName, int pageNumber})?>(
                  valueListenable: QuranLastReadHelper.lastReadNotifier,
                  builder: (context, lastRead, child) {
                    final displaySurahName = lastRead != null ? lastRead.surahName : 'البقرة';
                    final displayPageNumber = lastRead != null ? lastRead.pageNumber : 12;

                    return Container(
                      width: double.infinity,
                      height: 132,
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      decoration: BoxDecoration(
                        color: AppColors.authCardBorderColor,
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/quran_banner_1.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 16,
                        children: [
                          Column(
                            spacing: 2,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "تابع من حيث توقفت",
                                style: AppTextStyles.textTheme.labelMedium!
                                    .copyWith(fontSize: 20),
                              ),
                              Text(
                                "سورة $displaySurahName • صفحة $displayPageNumber",
                                style: AppTextStyles.textTheme.titleMedium,
                              ),
                            ],
                          ),
                          AppPrimaryButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.surahDetails,
                                arguments: {
                                  'surahName': 'سورة $displaySurahName',
                                  'initialPageNumber': displayPageNumber,
                                },
                              );
                            },
                            width: 100,
                            height: 30,
                            fontSize: 14,
                            radius: 4,
                            label: 'متابعة',
                          ),
                        ],
                      ),
                    );
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.quranSearch);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    alignment: AlignmentDirectional.centerStart,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      border: Border.all(
                        color: AppColors.borderColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ابحث عن سورة أو آية ...",
                          style: AppTextStyles.textTheme.titleSmall,
                        ),
                        Image.asset('assets/icons/iconoir_search.png'),
                      ],
                    ),
                  ),
                ),
                const CustomSurahSelector(),
                BlocBuilder<SurahSelectorCubit, int>(
                  builder: (context, selectedIndex) {
                    final cubit = context.read<SurahSelectorCubit>();
                    return DefaultTabController(
                      length: cubit.categories.length,
                      child: cubit.pages[selectedIndex],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
