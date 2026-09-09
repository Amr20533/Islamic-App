import 'package:adhan/adhan.dart';

void main() {
  final params = CalculationMethod.egyptian.getParameters();
  params.madhab = Madhab.shafi;
  final coordinates = Coordinates(30.0444, 31.2357);
  final date = DateComponents.from(DateTime.now());
  final prayerTimes = PrayerTimes(coordinates, date, params);

  print('Fajr: ${prayerTimes.fajr}');
  print('Dhuhr: ${prayerTimes.dhuhr}');
  print('Asr: ${prayerTimes.asr}');
  print('Maghrib: ${prayerTimes.maghrib}');
  print('Isha: ${prayerTimes.isha}');
}
