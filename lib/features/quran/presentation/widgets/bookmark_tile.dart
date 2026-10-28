import 'package:flutter/material.dart';
import 'package:islamic_app/features/quran/data/models/surah_category.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/utils/app_responsive.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final nameSize = AppResponsive.fontSize(context, mobile: 16, tablet: 15, web: 16);
    final metaSize = AppResponsive.fontSize(context, mobile: 14, tablet: 12, web: 13);
    final numSize = AppResponsive.fontSize(context, mobile: 14, tablet: 12, web: 13);
    final iconSize = AppResponsive.value<double>(context, mobile: 38, tablet: 34, web: 38);
    final rowHeight = AppResponsive.value<double>(context, mobile: 62, tablet: 54, web: 62);

    return Container(
      height: rowHeight,
      padding: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  width: 1,
                  color: isDark ? const Color(0xFF383430) : AppColors.borderColor,
                ),
              )
            : const Border(),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/icons/surah_number_container.png',
                width: iconSize,
                height: iconSize,
                color: isDark ? const Color(0xFFC8A88A) : null,
              ),
              Text(
                '${surahModel.number}',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: numSize,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFFF5F2EE) : null,
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
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: nameSize,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFFF5F2EE) : AppColors.thirdTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "${surahModel.number}",
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: metaSize,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFFB8AEA5) : AppColors.hintTextColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CircleAvatar(
                      radius: 2,
                      backgroundColor: isDark ? const Color(0xFFB8AEA5) : AppColors.hintTextColor,
                    ),
                  ),
                  Text(
                    '${surahModel.versesCount} ايات ',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: metaSize,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFFB8AEA5) : AppColors.hintTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            "${surahModel.wordsCount} حرف ",
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: metaSize,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFB8AEA5) : null,
            ),
          ),
        ],
      ),
    );
  }
}
