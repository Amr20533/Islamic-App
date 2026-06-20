import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/notification_service.dart';
import 'package:islamic_app/features/profile/domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  final NotificationService notificationService;

  ProfileCubit({required this.repository, required this.notificationService})
    : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final isEnabled = await repository.getDailyReminderEnabled();
      final reminderTime = await repository.getDailyReminderTime();
      final imagePath = await repository.getProfileImagePath();
      final name = await repository.getProfileName();
      final email = await repository.getProfileEmail();
      final password = await repository.getProfilePassword();
      emit(
        ProfileLoaded(
          isDailyReminderEnabled: isEnabled,
          dailyReminderTime: reminderTime,
          profileImagePath: imagePath,
          profileName: name,
          profileEmail: email,
          profilePassword: password,
        ),
      );
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> updateProfileImage(String path) async {
    if (state is! ProfileLoaded) return;
    final current = state as ProfileLoaded;
    await repository.saveProfileImagePath(path);
    emit(current.copyWith(profileImagePath: path));
  }

  Future<void> updateProfileName(String name) async {
    if (state is! ProfileLoaded) return;
    final current = state as ProfileLoaded;
    await repository.saveProfileName(name);
    emit(current.copyWith(profileName: name));
  }

  Future<void> updateProfileEmail(String email) async {
    if (state is! ProfileLoaded) return;
    final current = state as ProfileLoaded;
    await repository.saveProfileEmail(email);
    emit(current.copyWith(profileEmail: email));
  }

  Future<void> updateProfilePassword(String password) async {
    if (state is! ProfileLoaded) return;
    final current = state as ProfileLoaded;
    await repository.saveProfilePassword(password);
    emit(current.copyWith(profilePassword: password));
  }

  Future<void> toggleDailyReminder(bool enabled) async {
    if (state is! ProfileLoaded) return;
    final current = state as ProfileLoaded;

    await repository.saveDailyReminderEnabled(enabled);

    if (enabled) {
      // Parse stored time and schedule
      final timeStr = current.dailyReminderTime;
      final parsed = parseTimeForDisplay(timeStr);
      debugPrint("=== toggleDailyReminder ===");
      debugPrint("Stored time string: $timeStr");
      debugPrint(
        "Parsed hour: ${parsed.hour}, Parsed minute: ${parsed.minute}",
      );
      await notificationService.scheduleDailyReminderAt(
        hour: parsed.hour,
        minute: parsed.minute,
      );
      debugPrint(
        "Reminder scheduled at ${parsed.hour}:${parsed.minute.toString().padLeft(2, '0')}",
      );
    } else {
      await notificationService.cancelNotification(123);
      debugPrint("Reminder cancelled.");
    }

    emit(current.copyWith(isDailyReminderEnabled: enabled));
  }

  Future<void> updateReminderTime(TimeOfDay time) async {
    if (state is! ProfileLoaded) return;
    final current = state as ProfileLoaded;

    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    final timeStr = '${hour.toString().padLeft(2, '0')}:$minute $period';

    await repository.saveDailyReminderTime(timeStr);
    emit(current.copyWith(dailyReminderTime: timeStr));

    // Reschedule if enabled
    if (current.isDailyReminderEnabled) {
      await notificationService.scheduleDailyReminderAt(
        hour: time.hour,
        minute: time.minute,
      );
    }
  }

  /// Parses stored time string (e.g. "08:30 PM") into a TimeOfDay for display.
  TimeOfDay parseTimeForDisplay(String timeStr) {
    try {
      // Format: "08:00 AM" or "08:00 PM"
      final parts = timeStr.split(' ');
      final hm = parts[0].split(':');
      int hour = int.parse(hm[0]);
      final minute = int.parse(hm[1]);
      final isPm = parts.length > 1 && parts[1] == 'PM';
      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return const TimeOfDay(hour: 8, minute: 0);
    }
  }
}
