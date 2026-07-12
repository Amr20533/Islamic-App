import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'prayer_state.dart';

class PrayerCubit extends Cubit<PrayerState> {
  double latitude;
  double longitude;
  Timer? _timer;

  PrayerCubit({required this.latitude, required this.longitude})
      : super(PrayerInitial()) {
    init();
  }


  final CalculationParameters _params = CalculationMethodParameters.egyptian()
    ..madhab = Madhab.shafi;

  void init() {
    emit(PrayerLoading());
    _updatePrayerTimes();
    // Refresh every second for the real-time countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updatePrayerTimes();
    });
  }


  void _updatePrayerTimes() {
    try {
      final coordinates = Coordinates(latitude, longitude);
      final date = DateTime.now();
      final prayerTimes = PrayerTimes(
        coordinates: coordinates,
        date: date,
        calculationParameters: _params,
      );

      final now = DateTime.now();
      Map<String, DateTime> prayers = {
        "الفجر": prayerTimes.fajr,
        "الظهر": prayerTimes.dhuhr,
        "العصر": prayerTimes.asr,
        "المغرب": prayerTimes.maghrib,
        "العشاء": prayerTimes.isha,
      };

      String nextName = '';
      late DateTime nextTime;

      // Filter prayers that are in the future
      List<MapEntry<String, DateTime>> futurePrayers = prayers.entries
          .where((e) => e.value.isAfter(now))
          .toList();

      if (futurePrayers.isNotEmpty) {
        futurePrayers.sort((a, b) => a.value.compareTo(b.value));
        nextName = futurePrayers.first.key;
        nextTime = futurePrayers.first.value;
      } else {
        // If after Isha, get tomorrow's Fajr
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final tomorrowPrayerTimes = PrayerTimes(
          coordinates: coordinates,
          date: tomorrow,
          calculationParameters: _params,
        );
        nextName = "الفجر";
        nextTime = tomorrowPrayerTimes.fajr;
      }

      final todayPrayers = {
        "الفجر": prayerTimes.fajr,
        "الشروق": prayerTimes.sunrise,
        "الظهر": prayerTimes.dhuhr,
        "العصر": prayerTimes.asr,
        "المغرب": prayerTimes.maghrib,
        "العشاء": prayerTimes.isha,
      };

      final countdown = _calculateCountdown(nextTime);
      emit(
        PrayerLoaded(
          nextPrayerName: nextName,
          nextPrayerTime: nextTime,
          countdown: countdown,
          todayPrayers: todayPrayers,
        ),
      );
    } catch (e) {
      emit(PrayerError(e.toString()));
    }
  }

  String _calculateCountdown(DateTime nextTime) {
    final now = DateTime.now();
    final diff = nextTime.difference(now);

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }


  void updateLocation(double lat, double lng) {
    if ((latitude - lat).abs() < 0.01 && (longitude - lng).abs() < 0.01) {
      return;
    }
    latitude = lat;
    longitude = lng;
    init(); // re-run prayer time calculation with new coords
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
