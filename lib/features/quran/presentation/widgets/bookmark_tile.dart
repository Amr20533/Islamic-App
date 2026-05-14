import 'package:flutter/material.dart';
import 'package:islamic_app/features/quran/data/models/surah_category.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';

class BookmarkTile extends StatelessWidget {
  const BookmarkTile({
    super.key,
    required this.surahModel,
    this.isLast = false,
  });
  final SurahCategory surahModel;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(bottom: BorderSide(width: 1, color: AppColors.borderColor))
            : const Border(),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/icons/surah_number_container.png'),
              Text(
                '${surahModel.number}',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                surahModel.name,
                style: AppTextStyles.textTheme.titleLarge!.copyWith(
                  color: AppColors.thirdTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "${surahModel.number}",
                    style: AppTextStyles.textTheme.labelMedium!.copyWith(
                      color: AppColors.hintTextColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CircleAvatar(
                      radius: 2,
                      backgroundColor: AppColors.hintTextColor,
                    ),
                  ),
                  Text(
                    '${surahModel.versesCount} ايات ',
                    style: AppTextStyles.textTheme.labelMedium!.copyWith(
                      color: AppColors.hintTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            "${surahModel.wordsCount} حرف ",
            style: AppTextStyles.textTheme.labelMedium!.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
