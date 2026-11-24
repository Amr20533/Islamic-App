import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/helpers/Adhan_native_bridge.dart';
import 'package:islamic_app/core/services/notification_service.dart';
import 'package:islamic_app/features/prayer/domain/repositories/prayer_alarm_repository.dart';
import 'package:islamic_app/features/prayer/domain/entities/prayer_alarm_config.dart';
import 'prayer_alarm_state.dart';

class PrayerAlarmCubit extends Cubit<PrayerAlarmState> {
  final PrayerAlarmRepository repository;
  final NotificationService notificationService;
  final AdhanNativeBridge adhanBridge;

  PrayerAlarmCubit({
    required this.repository,
    required this.notificationService,
    required this.adhanBridge,
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

          // 1. تذكير هادئ قبل الأذان بـ 5 دقائق من فلاتر
          await notificationService.schedulePrayerReminder(
            id: config.notificationId,
            prayerName: config.name,
            prayerTime: prayerTime,
            minutesBefore: 5,
          );

          // 2. الأذان الحقيقي في وقته بالضبط من نظام أندرويد مع صوت الأذان وزر الإيقاف
          await adhanBridge.sync(
            id: config.key,
            enabled: true,
            time: TimeOfDay(hour: prayerTime.hour, minute: prayerTime.minute),
            label: config.name,
          );
          debugPrint('✅ 5-min reminder + Native adhan armed for ${config.name} at ${prayerTime.hour}:${prayerTime.minute}');
        }
      } else {
        // Cancel both: Flutter reminder + Native alarm
        await notificationService.cancelNotification(config.notificationId);
        await adhanBridge.sync(
          id: config.key,
          enabled: false,
          time: const TimeOfDay(hour: 0, minute: 0),
          label: config.name,
        );
        debugPrint('🗑 Native alarm cancelled for ${config.name}');
      }

      final updatedStates = Map<String, bool>.from(currentStates)
        ..[config.key] = isEnabled;
      emit(PrayerAlarmLoaded(alarmStates: updatedStates));
    } catch (e) {
      debugPrint('❌ toggleAlarm error for ${config.name}: $e');
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
          // 1. تذكير هادئ قبل الأذان بـ 5 دقائق من فلاتر
          await notificationService.schedulePrayerReminder(
            id: config.notificationId,
            prayerName: config.name,
            prayerTime: prayerTime,
            minutesBefore: 5,
          );

          // 2. الأذان الحقيقي في وقته بالضبط من نظام أندرويد الأصلي مع زر الإيقاف
          await adhanBridge.sync(
            id: config.key,
            enabled: true,
            time: TimeOfDay(hour: prayerTime.hour, minute: prayerTime.minute),
            label: config.name,
          );
          debugPrint('🔄 Rescheduled 5-min reminder + native adhan for ${config.name}');
        }
      } else {
        // Ensure native alarm is cancelled too
        await adhanBridge.sync(
          id: config.key,
          enabled: false,
          time: const TimeOfDay(hour: 0, minute: 0),
          label: config.name,
        );
      }
    }
    debugPrint('✅ PrayerAlarmCubit: all enabled alarms rescheduled (Flutter + Native)');
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
