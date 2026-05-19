import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/features/quran/presentation/pages/surah_details_view.dart';
import 'package:islamic_app/features/quran/data/models/quran_metadata.dart';

class JuzSlider extends StatelessWidget {
  const JuzSlider({super.key});

  final List<String> juzNames = const [
    "الجزء الأول", "الجزء الثاني", "الجزء الثالث", "الجزء الرابع", "الجزء الخامس",
    "الجزء السادس", "الجزء السابع", "الجزء الثامن", "الجزء التاسع", "الجزء العاشر",
    "الجزء الحادي عشر", "الجزء الثاني عشر", "الجزء الثالث عشر", "الجزء الرابع عشر", "الجزء الخامس عشر",
    "الجزء السادس عشر", "الجزء السابع عشر", "الجزء الثامن عشر", "الجزء التاسع عشر", "الجزء العشرون",
    "الجزء الحادي والعشرون", "الجزء الثاني والعشرون", "الجزء الثالث والعشرون", "الجزء الرابع والعشرون", "الجزء الخامس والعشرون",
    "الجزء السادس والعشرون", "الجزء السابع والعشرون", "الجزء الثامن والعشرون", "الجزء التاسع والعشرون", "الجزء الثلاثون"
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: ListView.separated(
          itemCount: 30,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            bool isLast = index == 29;
            return InkWell(
              onTap: () {
                int juzNumber = index + 1;
                var data = QuranMetadata.juzToSurah[juzNumber];
                if (data != null) {
                  context.read<QuranCubit>().loadSurahData(data['surahNumber']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurahDetailsView(
                        surahName: data['surahName'],
                        initialPageNumber: data['pageNumber'],
                      ),
                    ),
                  );
                }
              },
              child: Container(
                height: 62,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                  border: !isLast
                      ? Border(
                          bottom: BorderSide(
                              width: 1, color: AppColors.borderColor),
                        )
                      : const Border(),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/icons/surah_number_container.png'),
                        Text(
                          '${index + 1}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Text(
                      juzNames[index],
                      style: AppTextStyles.textTheme.titleLarge!.copyWith(
                        color: AppColors.thirdTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, _) => const SizedBox(height: 16),
        ),
      ),
    );
  }
}
