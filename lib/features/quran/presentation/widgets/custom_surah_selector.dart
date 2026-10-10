import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/quran/presentation/bloc/surah_selector_cubit.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';

class CustomSurahSelector extends StatelessWidget {
  const CustomSurahSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SurahSelectorCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 32,
      alignment: Alignment.center,
      child: Row(
        spacing: 8,
        children: List.generate(cubit.categories.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () => cubit.updateIndex(index),
              child: BlocBuilder<SurahSelectorCubit, int>(
                builder: (context, selectedIndex) {
                  bool isSelected = index == selectedIndex;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? const Color(0xFFC8A88A)
                              : AppColors.primaryColor)
                          : (isDark
                              ? const Color(0xFF211F1D)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        width: 1,
                        color: isSelected
                            ? Colors.transparent
                            : (isDark
                                ? const Color(0xFF383430)
                                : AppColors.borderColor),
                      ),
                    ),
                    child: Text(
                      cubit.categories[index],
                      style:
                          (AppTextStyles.textTheme.titleMedium ??
                                  const TextStyle())
                              .copyWith(
                                fontSize: 14,
                                color: isSelected
                                    ? (isDark
                                        ? const Color(0xFF141312)
                                        : AppColors.whiteColor)
                                    : (isDark
                                        ? const Color(0xFFB8AEA5)
                                        : AppColors.primaryColor),
                              ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
