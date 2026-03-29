import 'package:get/get.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:islamic_app/services/helpers/ramadan_service.dart';

class RamadanController extends GetxController {
  final RamadanService _service = RamadanService();

  var prayerTimes = Rxn<PrayerTimes>();
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrayerTimes();
  }

  // Get the name of the next prayer (e.g., Fajr, Dhuhr, etc.)
  String get nextPrayerName {
    if (prayerTimes.value == null) return "---";

    final next = prayerTimes.value!.nextPrayer();

    // If the library returns none, it means we are past Isha.
    // The next prayer is logically Fajr.
    if (next == Prayer.none) {
      return "الفجر";
    }

    return _translatePrayerName(next);
  }

  DateTime? get nextPrayerTime {
    if (prayerTimes.value == null) return null;

    final next = prayerTimes.value!.nextPrayer();

    if (next == Prayer.none) {
      // Calculate Fajr for tomorrow
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowDate = DateComponents.from(tomorrow);

      // You need to re-run the calculation for tomorrow's date
      final tomorrowTimes = PrayerTimes(
          prayerTimes.value!.coordinates,
          tomorrowDate,
          prayerTimes.value!.calculationParameters
      );

      return tomorrowTimes.fajr;
    }

    return prayerTimes.value!.timeForPrayer(next);
  }

  var saharOffset = 60.obs; // Default to 60 minutes

  DateTime? get saharTime {
    if (prayerTimes.value == null) return null;
    return prayerTimes.value!.fajr.subtract(Duration(minutes: saharOffset.value));
  }

  String get currentPeriodName {
    final now = DateTime.now();
    if (prayerTimes.value == null) return "";

    // If it's between Isha and Fajr, it's the period of Qiyam
    if (now.isAfter(prayerTimes.value!.isha) || now.isBefore(prayerTimes.value!.fajr)) {
      return "قيام الليل";
    }
    return "وقت العبادة";
  }

// Imsak (The moment you should stop eating - usually 10 mins before Fajr)
  DateTime? get imsakTime {
    if (prayerTimes.value == null) return null;
    return prayerTimes.value!.fajr.subtract(const Duration(minutes: 10));
  }
  // Helper to translate enum to Arabic/English string
  String _translatePrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr: return "الفجر";
      case Prayer.sunrise: return "الشروق";
      case Prayer.dhuhr: return "الظهر";
      case Prayer.asr: return "العصر";
      case Prayer.maghrib: return "المغرب (الإفطار)";
      case Prayer.isha: return "العشاء";
      case Prayer.none: return "قيام الليل";
      default: return "";
    }
  }

  Future<void> fetchPrayerTimes() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _service.getTodayTimes();
      prayerTimes.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }
}