import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/foundation.dart';

void main() {
  final coordinates = Coordinates(30.0444, 31.2357);
  final date = DateTime.now();
  final params = CalculationMethodParameters.egyptian();
  final prayerTimes = PrayerTimes(
    coordinates: coordinates,
    date: date,
    calculationParameters: params,
  );

  if (kDebugMode) {
    debugPrint("UTC Times:");
    debugPrint("Fajr: ${prayerTimes.fajr}");
    debugPrint("Sunrise: ${prayerTimes.sunrise}");
    debugPrint("Dhuhr: ${prayerTimes.dhuhr}");
    debugPrint("Asr: ${prayerTimes.asr}");
    debugPrint("Maghrib: ${prayerTimes.maghrib}");
    debugPrint("Isha: ${prayerTimes.isha}");

    debugPrint("\nLocal Times (via toLocal()):");
    debugPrint("Fajr: ${prayerTimes.fajr.toLocal()}");
    debugPrint("Sunrise: ${prayerTimes.sunrise.toLocal()}");
    debugPrint("Dhuhr: ${prayerTimes.dhuhr.toLocal()}");
    debugPrint("Asr: ${prayerTimes.asr.toLocal()}");
    debugPrint("Maghrib: ${prayerTimes.maghrib.toLocal()}");
    debugPrint("Isha: ${prayerTimes.isha.toLocal()}");
  }
}
