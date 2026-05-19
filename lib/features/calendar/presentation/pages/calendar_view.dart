import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/calendar/presentation/bloc/calendar_cubit.dart';
import 'package:islamic_app/features/calendar/presentation/bloc/calendar_state.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/calendar_header.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/calendar_days_slider.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/fard_prayers_card.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/sunnah_prayers_card.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/daily_points_card.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<CalendarCubit>()..initCalendar(),
      child: const _CalendarPageContent(),
    );
  }
}

class _CalendarPageContent extends StatelessWidget {
  const _CalendarPageContent();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'تقويم العبادات اليومية',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTextColor,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            if (state is CalendarInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CalendarLoaded) {
              final cubit = context.read<CalendarCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120), // Avoid overlap with bottom nav
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Calendar Header (Month navigation & Hijri Date)
                    CalendarHeader(
                      focusedMonth: state.focusedMonth,
                      selectedDate: state.selectedDate,
                      onPrevMonth: () {
                        final prev = DateTime(state.focusedMonth.year, state.focusedMonth.month - 1);
                        cubit.changeFocusedMonth(prev);
                      },
                      onNextMonth: () {
                        final next = DateTime(state.focusedMonth.year, state.focusedMonth.month + 1);
                        cubit.changeFocusedMonth(next);
                      },
                    ),

                    // 2. Horizontal Calendar days list
                    CalendarDaysSlider(
                      focusedMonth: state.focusedMonth,
                      selectedDate: state.selectedDate,
                      onDateSelected: (date) {
                        cubit.loadDate(date);
                      },
                    ),

                    const SizedBox(height: 12),

                    // 3. Fard Prayers Container (الفروض الخمسة)
                    FardPrayersCard(
                      fardStates: state.fardStates,
                      fardCount: state.fardCount,
                      onToggle: (index) {
                        cubit.toggleFard(index);
                      },
                    ),

                    // 4. Sunan Rawatib Container (السنن الرواتب)
                    SunnahPrayersCard(
                      sunnahStates: state.sunnahStates,
                      onToggle: (index) {
                        cubit.toggleSunnah(index);
                      },
                    ),

                    const SizedBox(height: 12),

                    // 5. Total Daily Points Container (مجموع نقاط اليوم)
                    DailyPointsCard(totalPoints: state.totalPoints),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
