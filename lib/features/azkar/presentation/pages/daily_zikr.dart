import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/daily_dhikr_cubit.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/tour_completed_card.dart';

class DailyZikr extends StatelessWidget {
  const DailyZikr({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightGreyColor,
        appBar: AppBar(
          backgroundColor: AppColors.lightGreyColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: context.primaryColor,
              size: 18,
            ),
          ),
          title: Text("ذكر اليوم", style: AppTextStyles.textTheme.titleLarge),
        ),
        body: SizedBox.expand(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\"استغفر الله\"",
                      style: AppTextStyles.textTheme.displayLarge?.copyWith(
                        fontFamily: 'QuranFont',
                        fontSize: 48,
                      ),
                    ),
                    BlocBuilder<DailyDhikrCubit, DailyDhikrState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () =>
                              context.read<DailyDhikrCubit>().incrementCount(),
                          child: Container(
                            width: 271,
                            height: 271,
                            margin: const EdgeInsets.only(top: 77, bottom: 41),
                            decoration: BoxDecoration(
                              color: context.tertiaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: AppColors.lightGreyColor,
                              ),
                              boxShadow: context.softShadow,
                            ),
                            child: Center(
                              child: Text(
                                "${state.count} / ${state.maxCount}",
                                style: AppTextStyles.textTheme.displaySmall
                                    ?.copyWith(height: 1),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      "اضغط للعد",
                      style: AppTextStyles.textTheme.labelSmall?.copyWith(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              BlocBuilder<DailyDhikrCubit, DailyDhikrState>(
                builder: (context, state) {
                  if (state.isCompleted) {
                    return const Align(
                      alignment: Alignment.center,
                      child: TourCompletedCard(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
