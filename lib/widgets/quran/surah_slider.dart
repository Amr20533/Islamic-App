import 'package:flutter/material.dart';
import 'package:islamic_app/core/controllers/quran_controller.dart';
import 'package:islamic_app/core/models/quran/surah_category.dart';
import 'package:islamic_app/core/models/surah_model.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/widgets/quran/surah_tile.dart';

class SurahSlider extends StatelessWidget {
  const SurahSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = locator<QuranController>();

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
          separatorBuilder: (context, _) => const SizedBox(height: 16),),
      ),
    );
  }
}
