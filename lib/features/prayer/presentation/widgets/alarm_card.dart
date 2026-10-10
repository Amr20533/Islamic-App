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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242220) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? const Color(0xFF383430)
              : AppColors.borderColor.withOpacity(0.35),
          width: 1,
        ),
        boxShadow: isDark
            ? const []
            : [
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
                      if (prayerState is PrayerLoading || prayerState is PrayerInitial) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (prayerState is PrayerError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Text(
                                prayerState.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 14,
                                  color: isDark ? const Color(0xFFC8A88A) : AppColors.counterColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.counterColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<PrayerCubit>().refreshLocation();
                                },
                                icon: const Icon(Icons.my_location, size: 18, color: Colors.white),
                                label: const Text(
                                  'تحديد / تحديث الموقع',
                                  style: TextStyle(fontFamily: 'Tajawal', color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

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
                              Divider(
                                height: 1,
                                thickness: 0.5,
                                color: isDark
                                    ? const Color(0xFF383430)
                                    : AppColors.borderColor,
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
