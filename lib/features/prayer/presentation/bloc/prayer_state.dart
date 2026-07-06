import 'package:equatable/equatable.dart';

abstract class PrayerState extends Equatable {
  const PrayerState();

  @override
  List<Object?> get props => [];
}

class PrayerInitial extends PrayerState {}

class PrayerLoading extends PrayerState {}

class PrayerLoaded extends PrayerState {
  final String nextPrayerName;
  final DateTime nextPrayerTime;
  final String countdown;
  final Map<String, DateTime> todayPrayers;

  const PrayerLoaded({
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.countdown,
    required this.todayPrayers,
  });

  @override
  List<Object?> get props => [nextPrayerName, nextPrayerTime, countdown, todayPrayers];

  PrayerLoaded copyWith({
    String? nextPrayerName,
    DateTime? nextPrayerTime,
    String? countdown,
    Map<String, DateTime>? todayPrayers,
  }) {
    return PrayerLoaded(
      nextPrayerName: nextPrayerName ?? this.nextPrayerName,
      nextPrayerTime: nextPrayerTime ?? this.nextPrayerTime,
      countdown: countdown ?? this.countdown,
      todayPrayers: todayPrayers ?? this.todayPrayers,
    );
  }
}

class PrayerError extends PrayerState {
  final String message;
  const PrayerError(this.message);

  @override
  List<Object?> get props => [message];
}
