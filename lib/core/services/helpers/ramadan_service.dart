import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';

class RamadanService {
  Future<PrayerTimes> getTodayTimes() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // Now it's safe to get the position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final myCoordinates = Coordinates(position.latitude, position.longitude);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    final date = DateComponents.from(DateTime.now());

    return PrayerTimes(myCoordinates, date, params);
  }

  static String getCountdownToIftar(PrayerTimes times) {
    final now = DateTime.now();
    final iftarTime = times.maghrib;

    if (now.isAfter(iftarTime)) {
      return "تقبل الله طاعتكم / انتهى وقت الإفطار"; // "May Allah accept / Iftar passed"
    }

    final duration = iftarTime.difference(now);

    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    String timeString = "$hours:$minutes:$seconds";
    return FormatHelper.replaceWithArabicNumbers(timeString);
  }
}
