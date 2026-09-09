import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
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
        height: 62,
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
                  color: isDark ? const Color(0xFFC8A88A) : null,
                ),
                Text(
                  '${surahModel.number}',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontSize: 14,
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
                  style: (AppTextStyles.textTheme.titleLarge ?? const TextStyle()).copyWith(
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
                      style: (AppTextStyles.textTheme.labelMedium ?? const TextStyle()).copyWith(
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
                      style: (AppTextStyles.textTheme.labelMedium ?? const TextStyle()).copyWith(
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
