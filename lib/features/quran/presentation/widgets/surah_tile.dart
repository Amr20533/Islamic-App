import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/utils/app_responsive.dart';
import 'package:islamic_app/features/quran/data/models/surah_category.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';

class SurahTile extends StatelessWidget {
  const SurahTile({super.key, required this.surahModel, this.isLast = false});
  final SurahCategory surahModel;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Responsive sizes — keep tablet text comfortable but not giant
    final surahNameSize = AppResponsive.fontSize(
      context,
      mobile: 16,
      tablet: 15,
      web: 16,
    );
    final surahMetaSize = AppResponsive.fontSize(
      context,
      mobile: 13,
      tablet: 12,
      web: 13,
    );
    final numberSize = AppResponsive.fontSize(
      context,
      mobile: 13,
      tablet: 12,
      web: 13,
    );
    final iconImageSize = AppResponsive.value<double>(
      context,
      mobile: 38,
      tablet: 34,
      web: 38,
    );
    final rowHeight = AppResponsive.value<double>(
      context,
      mobile: 62,
      tablet: 56,
      web: 62,
    );

    return GestureDetector(
      onTap: () {
        context.read<QuranCubit>().loadSurahData(surahModel.number);
        Navigator.pushNamed(
          context,
          AppRoutes.surahDetails,
          arguments: {'surahName': surahModel.name},
        );
      },
      child: Container(
        height: rowHeight,
        padding: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          border: !isLast
              ? Border(
                  bottom: BorderSide(
                    width: 1,
                    color: isDark
                        ? const Color(0xFF383430)
                        : AppColors.borderColor,
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
                  width: iconImageSize,
                  height: iconImageSize,
                  color: isDark ? const Color(0xFFC8A88A) : null,
                ),
                Text(
                  '${surahModel.number}',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: numberSize,
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
                  surahModel.name.startsWith('سورة')
                      ? surahModel.name
                      : 'سورة ${surahModel.name}',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: surahNameSize,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFFF5F2EE)
                        : AppColors.thirdTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${surahModel.number}",
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: surahMetaSize,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFFB8AEA5)
                            : AppColors.hintTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CircleAvatar(
                        radius: 2,
                        backgroundColor: isDark
                            ? const Color(0xFFB8AEA5)
                            : AppColors.hintTextColor,
                      ),
                    ),
                    Text(
                      '${surahModel.versesCount} ايات ',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: surahMetaSize,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFFB8AEA5)
                            : AppColors.hintTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
