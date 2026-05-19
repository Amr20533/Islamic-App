import 'package:flutter/material.dart';
import 'package:islamic_app/features/quran/data/models/surah_category.dart';
import 'package:islamic_app/features/quran/presentation/widgets/surah_tile.dart';

class SurahSlider extends StatelessWidget {
  const SurahSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: ListView.separated(
          itemCount: SurahCategory.surahCategories.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            SurahCategory surah = SurahCategory.surahCategories[index];
            bool isLast = index == SurahCategory.surahCategories.length - 1;
            return SurahTile(surahModel: surah, isLast: isLast);
          },
          separatorBuilder: (context, _) => const SizedBox(height: 16),
        ),
      ),
    );
  }
}
