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

  const PrayerLoaded({
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.countdown,
  });

  @override
  List<Object?> get props => [nextPrayerName, nextPrayerTime, countdown];

  PrayerLoaded copyWith({
    String? nextPrayerName,
    DateTime? nextPrayerTime,
    String? countdown,
  }) {
    return PrayerLoaded(
      nextPrayerName: nextPrayerName ?? this.nextPrayerName,
      nextPrayerTime: nextPrayerTime ?? this.nextPrayerTime,
      countdown: countdown ?? this.countdown,
    );
  }
}

class PrayerError extends PrayerState {
  final String message;
  const PrayerError(this.message);

  @override
  List<Object?> get props => [message];
}
