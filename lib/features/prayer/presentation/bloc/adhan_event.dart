import 'package:equatable/equatable.dart';
import 'package:adhan/adhan.dart';

abstract class AdhanEvent extends Equatable {
  const AdhanEvent();

  @override
  List<Object?> get props => [];
}

class AdhanInitializeEvent extends AdhanEvent {}

class AdhanScheduleEvent extends AdhanEvent {
  final PrayerTimes prayerTimes;
  const AdhanScheduleEvent(this.prayerTimes);

  @override
  List<Object?> get props => [prayerTimes];
}

class AdhanPlayEvent extends AdhanEvent {
  final String prayerName;
  const AdhanPlayEvent(this.prayerName);

  @override
  List<Object?> get props => [prayerName];
}

class AdhanStopEvent extends AdhanEvent {}
