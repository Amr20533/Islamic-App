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
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        width: 1,
                        color: isSelected
                            ? Colors.transparent
                            : AppColors.borderColor,
                      ),
                    ),
                    child: Text(
                      cubit.categories[index],
                      style:
                          (AppTextStyles.textTheme.titleMedium ??
                                  const TextStyle())
                              .copyWith(
                                fontSize: 16,
                                color: isSelected
                                    ? AppColors.whiteColor
                                    : AppColors.primaryColor,
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
