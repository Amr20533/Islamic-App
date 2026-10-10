import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/notification_service.dart';
import 'package:islamic_app/features/prayer/domain/repositories/prayer_alarm_repository.dart';
import 'package:islamic_app/features/prayer/domain/entities/prayer_alarm_config.dart';
import 'prayer_alarm_state.dart';

class PrayerAlarmCubit extends Cubit<PrayerAlarmState> {
  final PrayerAlarmRepository repository;
  final NotificationService notificationService;

  PrayerAlarmCubit({
    required this.repository,
    required this.notificationService,
  }) : super(PrayerAlarmInitial());

  Future<void> loadAlarms(List<PrayerAlarmConfig> configs) async {
    emit(PrayerAlarmLoading());
    try {
      final keys = configs.map((c) => c.key).toList();
      final alarmStates = await repository.getAlarmStates(keys);
      emit(PrayerAlarmLoaded(alarmStates: alarmStates));
    } catch (e) {
      emit(PrayerAlarmError(message: e.toString()));
    }
  }

  Future<void> toggleAlarm({
    required PrayerAlarmConfig config,
    required DateTime? prayerTime,
    required bool isEnabled,
  }) async {
    if (state is! PrayerAlarmLoaded) return;
    final currentStates = (state as PrayerAlarmLoaded).alarmStates;

    try {
      await repository.saveAlarmState(config.key, isEnabled);

      if (isEnabled) {
        if (prayerTime != null) {
          await _ensureInitialized();
          await notificationService.schedulePrayerNotification(
            id: config.notificationId,
            prayerName: config.name,
            prayerTime: prayerTime,
          );
        }
      } else {
        await notificationService.cancelNotification(config.notificationId);
      }

      final updatedStates = Map<String, bool>.from(currentStates)
        ..[config.key] = isEnabled;
      emit(PrayerAlarmLoaded(alarmStates: updatedStates));
    } catch (e) {
      emit(PrayerAlarmError(message: e.toString()));
    }
  }

  Future<void> rescheduleEnabledAlarms({
    required List<PrayerAlarmConfig> configs,
    required Map<String, DateTime> todayPrayers,
  }) async {
    if (state is! PrayerAlarmLoaded) return;
    final alarmStates = (state as PrayerAlarmLoaded).alarmStates;

    await _ensureInitialized();

    for (final config in configs) {
      await notificationService.cancelNotification(config.notificationId);

      if (alarmStates[config.key] == true) {
        final prayerTime = todayPrayers[config.name];
        if (prayerTime != null) {
          await notificationService.schedulePrayerNotification(
            id: config.notificationId,
            prayerName: config.name,
            prayerTime: prayerTime,
          );
        }
      }
    }
    debugPrint('✅ PrayerAlarmCubit: all enabled alarms rescheduled');
  }

  /// Waits until [NotificationService] has finished initializing.
  /// Retries every 500ms up to 10 times (5 seconds total).
  Future<void> _ensureInitialized() async {
    for (int i = 0; i < 10; i++) {
      if (notificationService.isInitialized) return;
      debugPrint('⏳ Waiting for NotificationService init... attempt ${i + 1}');
      await Future.delayed(const Duration(milliseconds: 500));
    }
    debugPrint(
      '⚠️ NotificationService still not initialized after 5s — proceeding anyway',
    );
  }
}
