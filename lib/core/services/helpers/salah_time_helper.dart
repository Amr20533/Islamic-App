import 'package:islamic_app/core/services/prayer_calculation_service.dart';

/// Helper for accessing prayer times at arbitrary coordinates.
/// Delegates all calculation to [PrayerCalculationService] (single source of truth).
class SalahTimeHelper {
  final double latitude;
  final double longitude;

  SalahTimeHelper({required this.latitude, required this.longitude});

  /// Returns a map of today's prayer times using the user's saved settings.
  Future<Map<String, DateTime>> getSalahTimes() {
    return PrayerCalculationService.calculatePrayerTimes(
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Returns a single-entry map { nextPrayerName: nextPrayerTime }.
  Future<Map<String, DateTime>> getNextPrayer() async {
    final prayers = await PrayerCalculationService.calculatePrayerTimes(
      latitude: latitude,
      longitude: longitude,
    );

    final now = DateTime.now();

    // Check each prayer in order (the map is already insertion-ordered)
    final ordered = ["الفجر", "الشروق", "الظهر", "العصر", "المغرب", "العشاء"];
    for (final name in ordered) {
      final time = prayers[name];
      if (time != null && now.isBefore(time)) {
        return {name: time};
      }
    }

    // If after Isha, next prayer is tomorrow's Fajr
    final tomorrowPrayers = await PrayerCalculationService.calculatePrayerTimes(
      latitude: latitude,
      longitude: longitude,
      date: DateTime.now().add(const Duration(days: 1)),
    );
    return {"الفجر": tomorrowPrayers["الفجر"]!};
  }
}
