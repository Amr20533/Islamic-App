import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/features/quran/presentation/pages/surah_details_view.dart';
import 'package:islamic_app/features/quran/data/models/quran_metadata.dart';

class PageSlider extends StatelessWidget {
  const PageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: ListView.separated(
          itemCount: 604,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            bool isLast = index == 603;
            return InkWell(
              onTap: () {
                int pageNumber = index + 1;
                var data = QuranMetadata.pageToSurah[pageNumber];
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
                      "الصفحة ${index + 1}",
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
