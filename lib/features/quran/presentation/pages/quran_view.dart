import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/features/quran/presentation/bloc/surah_selector_cubit.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/features/quran/presentation/widgets/custom_surah_selector.dart';

class QuranView extends StatelessWidget {
  const QuranView({super.key});

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
                Container(
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
                            "سورة البقرة • صفحة 12",
                            style: AppTextStyles.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      AppPrimaryButton(
                        onPressed: () {},
                        width: 100,
                        height: 30,
                        fontSize: 14,
                        radius: 4,
                        label: 'متابعة',
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  alignment: AlignmentDirectional.centerStart,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    border: Border.all(color: AppColors.borderColor, width: 1),
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
