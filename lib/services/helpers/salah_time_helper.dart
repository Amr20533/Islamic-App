import 'package:adhan_dart/adhan_dart.dart';

class SalahTimeHelper {
  final double latitude;
  final double longitude;

  SalahTimeHelper({required this.latitude, required this.longitude});

  /// Returns a map of prayer times
  Map<String, DateTime> getSalahTimes() {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethodParameters.egyptian();
    final date = DateTime.now();

    final prayerTimes = PrayerTimes(
      coordinates: coordinates,
      date: date,
      calculationParameters: params,
    );

    return {
      "Fajr": prayerTimes.fajr,
      "Dhuhr": prayerTimes.dhuhr,
      "Asr": prayerTimes.asr,
      "Maghrib": prayerTimes.maghrib,
      "Isha": prayerTimes.isha,
    };
  }

  /// Returns the name of the next prayer and the DateTime
  Map<String, DateTime> getNextPrayer() {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethodParameters.egyptian();
    final date = DateTime.now();

    final prayerTimes = PrayerTimes(
      coordinates: coordinates,
      date: date,
      calculationParameters: params,
    );

    final now = DateTime.now();

    // Check each prayer in order
    if (now.isBefore(prayerTimes.fajr)) return {"Fajr": prayerTimes.fajr};
    if (now.isBefore(prayerTimes.dhuhr)) return {"Dhuhr": prayerTimes.dhuhr};
    if (now.isBefore(prayerTimes.asr)) return {"Asr": prayerTimes.asr};
    if (now.isBefore(prayerTimes.maghrib)) return {"Maghrib": prayerTimes.maghrib};
    if (now.isBefore(prayerTimes.isha)) return {"Isha": prayerTimes.isha};

    // If after Isha, next prayer is tomorrow Fajr
    final tomorrow = DateTime.now().add(Duration(days: 1));
    final tomorrowPrayerTimes = PrayerTimes(
      coordinates: coordinates,
      date: tomorrow,
      calculationParameters: params,
    );
    return {"Fajr": tomorrowPrayerTimes.fajr};
  }
}
