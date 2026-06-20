abstract class PrayerAlarmState {}

class PrayerAlarmInitial extends PrayerAlarmState {}

class PrayerAlarmLoading extends PrayerAlarmState {}

class PrayerAlarmLoaded extends PrayerAlarmState {
  final Map<String, bool> alarmStates;

  PrayerAlarmLoaded({required this.alarmStates});
}

class PrayerAlarmError extends PrayerAlarmState {
  final String message;

  PrayerAlarmError({required this.message});
}
