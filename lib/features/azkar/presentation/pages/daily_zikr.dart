import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/daily_dhikr_cubit.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/tour_completed_card.dart';
import 'package:islamic_app/core/constants/daily_content.dart';

class DailyZikr extends StatefulWidget {
  const DailyZikr({super.key});

  @override
  State<DailyZikr> createState() => _DailyZikrState();
}

class _DailyZikrState extends State<DailyZikr> {
  late final Map<String, dynamic> _currentDhikr;

  @override
  void initState() {
    super.initState();
    final index = DailyContent.getDayOfYearIndex(DailyContent.adhkhar.length);
    _currentDhikr = DailyContent.adhkhar[index];

    // Initialize the Cubit with the daily maxCount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DailyDhikrCubit>().initDhikr(
          _currentDhikr['maxCount'] as int,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: isDark ? const Color(0xFFC8A88A) : context.primaryColor,
              size: 18,
            ),
          ),
          title: Text("ذكر اليوم", style: theme.textTheme.titleLarge),
        ),
        body: SizedBox.expand(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        _currentDhikr['text'] as String,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontFamily: 'Tajawal',
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFFF5F2EE) : AppColors.primaryTextColor,
                        ),
                        textAlign: TextAlign.center,
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
                              color: isDark ? const Color(0xFF282522) : context.tertiaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: isDark ? const Color(0xFF383430) : AppColors.lightGreyColor,
                              ),
                              boxShadow: context.softShadow,
                            ),
                            child: Center(
                              child: Text(
                                "${state.count} / ${state.maxCount}",
                                style: theme.textTheme.displaySmall?.copyWith(
                                  height: 1,
                                  color: isDark ? const Color(0xFFC8A88A) : null,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      "اضغط للعد",
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 18,
                        color: isDark ? const Color(0xFFB8AEA5) : null,
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
