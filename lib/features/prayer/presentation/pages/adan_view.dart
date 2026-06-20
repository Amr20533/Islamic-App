import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/features/prayer/domain/entities/prayer_alarm_config.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_alarm_cubit.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_cubit.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_state.dart';
import 'package:islamic_app/features/prayer/presentation/widgets/adan_view_header.dart';
import 'package:islamic_app/features/prayer/presentation/widgets/alarm_card.dart';
import 'package:islamic_app/features/prayer/presentation/widgets/next_prayer_virtue_card.dart';

class AdanView extends StatelessWidget {
  const AdanView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PrayerAlarmCubit>(
      create: (context) => locator<PrayerAlarmCubit>()..loadAlarms(prayerAlarmConfigs),
      child: const Directionality(
        textDirection: TextDirection.rtl,
        child: _AdanPageContent(),
      ),
    );
  }
}

class _AdanPageContent extends StatefulWidget {
  const _AdanPageContent();

  @override
  State<_AdanPageContent> createState() => _AdanPageContentState();
}

class _AdanPageContentState extends State<_AdanPageContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final prayerState = context.read<PrayerCubit>().state;
      if (prayerState is PrayerLoaded) {
        context.read<PrayerAlarmCubit>().rescheduleEnabledAlarms(
              configs: prayerAlarmConfigs,
              todayPrayers: prayerState.todayPrayers,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AdanViewHeader(),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: AlarmCard(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: NextPrayerVirtueCard(),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
