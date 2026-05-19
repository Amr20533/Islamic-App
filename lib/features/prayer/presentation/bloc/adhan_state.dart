import 'package:equatable/equatable.dart';

abstract class AdhanState extends Equatable {
  const AdhanState();

  @override
  List<Object?> get props => [];
}

class AdhanInitial extends AdhanState {}

class AdhanLoading extends AdhanState {}

class AdhanIdle extends AdhanState {}

class AdhanPlaying extends AdhanState {
  final String prayerName;
  const AdhanPlaying(this.prayerName);

  @override
  List<Object?> get props => [prayerName];
}

class AdhanError extends AdhanState {
  final String message;
  const AdhanError(this.message);

  @override
  List<Object?> get props => [message];
}
