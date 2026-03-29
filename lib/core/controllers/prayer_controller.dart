import 'package:get/get.dart';
import 'package:adhan_dart/adhan_dart.dart';

class PrayerController extends GetxController {
  final double latitude;
  final double longitude;

  PrayerController({required this.latitude, required this.longitude});

  // Reactive variables
  var nextPrayerName = ''.obs;
  var nextPrayerTime = DateTime.now().obs;
  var countdown = ''.obs;

  late PrayerTimes _todayPrayerTimes;

  // Initialize params immediately (no late)
  final CalculationParameters _params = CalculationMethodParameters.egyptian();

  @override
  void onInit() {
    super.onInit();

    // Make sure latitude/longitude are ready
    _calculatePrayerTimes();
    _updateNextPrayer();

    // Optional: auto-refresh countdown every minute
    // Timer.periodic(Duration(seconds: 60), (_) => refresh());
  }

  /// Calculate today's prayer times
  void _calculatePrayerTimes() {
    final coordinates = Coordinates(latitude, longitude);
    final date = DateTime.now();
    _todayPrayerTimes = PrayerTimes(
      coordinates: coordinates,
      date: date,
      calculationParameters: _params,
    );
  }

  /// Find the next prayer
  void _updateNextPrayer() {
    final now = DateTime.now();

    Map<String, DateTime> prayers = {
      "Fajr": _todayPrayerTimes.fajr,
      "Dhuhr": _todayPrayerTimes.dhuhr,
      "Asr": _todayPrayerTimes.asr,
      "Maghrib": _todayPrayerTimes.maghrib,
      "Isha": _todayPrayerTimes.isha,
    };

    String nextName = '';
    DateTime nextTime = now;

    prayers.forEach((name, time) {
      if (now.isBefore(time) && nextName.isEmpty) {
        nextName = name;
        nextTime = time;
      }
    });

    // If after Isha, get tomorrow Fajr
    if (nextName.isEmpty) {
      final coordinates = Coordinates(latitude, longitude);
      final tomorrow = DateTime.now().add(Duration(days: 1));
      final tomorrowPrayerTimes = PrayerTimes(
        coordinates: coordinates,
        date: tomorrow,
        calculationParameters: _params,
      );
      nextName = "Fajr";
      nextTime = tomorrowPrayerTimes.fajr;
    }

    nextPrayerName.value = nextName;
    nextPrayerTime.value = nextTime;

    _updateCountdown();
  }

  /// Countdown to next prayer
  void _updateCountdown() {
    final now = DateTime.now();
    final diff = nextPrayerTime.value.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    countdown.value =
    '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Optional: Call this every minute if you want live countdown
  @override
  void refresh() {
    _calculatePrayerTimes();
    _updateNextPrayer();
  }
}
