import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/prayer/domain/entities/prayer_alarm_config.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_alarm_cubit.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_alarm_state.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_cubit.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_state.dart';
import 'package:islamic_app/features/prayer/presentation/widgets/prayer_alarm_row.dart';

class AlarmCard extends StatelessWidget {
  const AlarmCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            BlocBuilder<PrayerAlarmCubit, PrayerAlarmState>(
              builder: (context, alarmState) {
                if (alarmState is PrayerAlarmLoading ||
                    alarmState is PrayerAlarmInitial) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  );
                } else if (alarmState is PrayerAlarmError) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      alarmState.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (alarmState is PrayerAlarmLoaded) {
                  final alarmStates = alarmState.alarmStates;

                  return BlocBuilder<PrayerCubit, PrayerState>(
                    builder: (context, prayerState) {
                      final todayPrayers = prayerState is PrayerLoaded
                          ? prayerState.todayPrayers
                          : <String, DateTime>{};

                      return Column(
                        children: [
                          for (
                            int i = 0;
                            i < prayerAlarmConfigs.length;
                            i++
                          ) ...[
                            PrayerAlarmRow(
                              name: prayerAlarmConfigs[i].name,
                              time: todayPrayers[prayerAlarmConfigs[i].name],
                              iconPath: prayerAlarmConfigs[i].iconPath,
                              isEnabled:
                                  alarmStates[prayerAlarmConfigs[i].key] ??
                                  false,
                              onToggle: (val) {
                                context.read<PrayerAlarmCubit>().toggleAlarm(
                                  config: prayerAlarmConfigs[i],
                                  prayerTime:
                                      todayPrayers[prayerAlarmConfigs[i].name],
                                  isEnabled: val,
                                );
                              },
                            ),
                            if (i < prayerAlarmConfigs.length - 1)
                              const Divider(
                                height: 1,
                                thickness: 0.5,
                                color: AppColors.borderColor,
                              ),
                          ],
                        ],
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
