import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/features/calendar/presentation/bloc/calendar_cubit.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_cubit.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_state.dart';
import 'package:islamic_app/core/services/helpers/islamic_occasion_helper.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/calendar_view_header.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/next_prayer_countdown_card.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/prayer_times_card.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/islamic_occasion_card.dart';

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
        backgroundColor: const Color(0xFFF7F5F0),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CalendarViewHeader(
                  hijriDate: FormatHelper.getHijriFormattedDate(),
                  gregorianDate: FormatHelper.getMiladFormattedDate(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<PrayerCubit, PrayerState>(
                    builder: (context, state) {
                      if (state is PrayerLoaded) {
                        return NextPrayerCountdownCard(
                          nextPrayerName: state.nextPrayerName,
                          countdown: state.countdown,
                        );
                      }
                      if (state is PrayerLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<PrayerCubit, PrayerState>(
                    builder: (context, state) {
                      final todayPrayers = state is PrayerLoaded
                          ? state.todayPrayers
                          : <String, DateTime>{};

                      return PrayerTimesCard(todayPrayers: todayPrayers);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 24,
                  ),
                  child: Builder(
                    builder: (context) {
                      final occasionData =
                          IslamicOccasionHelper.getNextOccasion();
                      return IslamicOccasionCard(
                        occasion: occasionData.occasion,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}