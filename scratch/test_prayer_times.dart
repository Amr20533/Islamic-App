import 'package:adhan_dart/adhan_dart.dart';

void main() {
  final coordinates = Coordinates(30.0444, 31.2357);
  final date = DateTime.now();
  final params = CalculationMethodParameters.egyptian();
  final prayerTimes = PrayerTimes(
    coordinates: coordinates,
    date: date,
    calculationParameters: params,
  );

  print("UTC Times:");
  print("Fajr: ${prayerTimes.fajr}");
  print("Sunrise: ${prayerTimes.sunrise}");
  print("Dhuhr: ${prayerTimes.dhuhr}");
  print("Asr: ${prayerTimes.asr}");
  print("Maghrib: ${prayerTimes.maghrib}");
  print("Isha: ${prayerTimes.isha}");

  print("\nLocal Times (via toLocal()):");
  print("Fajr: ${prayerTimes.fajr.toLocal()}");
  print("Sunrise: ${prayerTimes.sunrise.toLocal()}");
  print("Dhuhr: ${prayerTimes.dhuhr.toLocal()}");
  print("Asr: ${prayerTimes.asr.toLocal()}");
  print("Maghrib: ${prayerTimes.maghrib.toLocal()}");
  print("Isha: ${prayerTimes.isha.toLocal()}");
}
