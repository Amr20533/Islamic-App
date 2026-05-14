import 'package:adhan/adhan.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/helpers/ramadan_service.dart';
import 'package:equatable/equatable.dart';

abstract class RamadanState extends Equatable {
  const RamadanState();
  @override
  List<Object?> get props => [];
}

class RamadanInitial extends RamadanState {}

class RamadanLoading extends RamadanState {}

class RamadanLoaded extends RamadanState {
  final PrayerTimes prayerTimes;
  final int saharOffset;

  const RamadanLoaded({required this.prayerTimes, this.saharOffset = 60});

  @override
  List<Object?> get props => [prayerTimes, saharOffset];

  String get nextPrayerName {
    final next = prayerTimes.nextPrayer();
    if (next == Prayer.none) return "الفجر";
    return _translatePrayerName(next);
  }

  DateTime? get nextPrayerTime {
    final next = prayerTimes.nextPrayer();
    if (next == Prayer.none) {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowDate = DateComponents.from(tomorrow);
      final tomorrowTimes = PrayerTimes(
        prayerTimes.coordinates,
        tomorrowDate,
        prayerTimes.calculationParameters,
      );
      return tomorrowTimes.fajr;
    }
    return prayerTimes.timeForPrayer(next);
  }

  DateTime get saharTime =>
      prayerTimes.fajr.subtract(Duration(minutes: saharOffset));
  DateTime get imsakTime =>
      prayerTimes.fajr.subtract(const Duration(minutes: 10));

  String get currentPeriodName {
    final now = DateTime.now();
    if (now.isAfter(prayerTimes.isha) || now.isBefore(prayerTimes.fajr)) {
      return "قيام الليل";
    }
    return "وقت العبادة";
  }

  String _translatePrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return "الفجر";
      case Prayer.sunrise:
        return "الشروق";
      case Prayer.dhuhr:
        return "الظهر";
      case Prayer.asr:
        return "العصر";
      case Prayer.maghrib:
        return "المغرب (الإفطار)";
      case Prayer.isha:
        return "العشاء";
      default:
        return "";
    }
  }
}

class RamadanError extends RamadanState {
  final String message;
  const RamadanError(this.message);
  @override
  List<Object?> get props => [message];
}

class RamadanCubit extends Cubit<RamadanState> {
  final RamadanService _service = RamadanService();

  RamadanCubit() : super(RamadanInitial());

  Future<void> fetchPrayerTimes() async {
    emit(RamadanLoading());
    try {
      final result = await _service.getTodayTimes();
      emit(RamadanLoaded(prayerTimes: result));
    } catch (e) {
      emit(RamadanError(e.toString()));
    }
  }
}
