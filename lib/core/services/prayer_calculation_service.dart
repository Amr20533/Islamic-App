import 'package:adhan/adhan.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Single source of truth for prayer time calculations across the app.
/// Uses [package:adhan] for calculation logic.
class PrayerCalculationService {
  static const String keyMethod = 'prayer_calc_method';
  static const String keyMadhab = 'prayer_madhab';

  /// Map of method keys to user-friendly Arabic names.
  static const Map<String, String> availableMethods = {
    'auto': 'تلقائي (حسب الموقع الجغرافي)',
    'egyptian': 'الهيئة المصرية العامة للمساحة',
    'umm_al_qura': 'أم القرى (المملكة العربية السعودية)',
    'muslim_world_league': 'رابطة العالم الإسلامي',
    'karachi': 'جامعة العلوم الإسلامية بكراتشي',
    'north_america': 'الجمعية الإسلامية لشمال أمريكا (ISNA)',
    'dubai': 'دائرة الشؤون الإسلامية بدبي',
    'kuwait': 'وزارة الأوقاف والشؤون الإسلامية بالكويت',
    'qatar': 'وزارة الأوقاف والشؤون الإسلامية بقطر',
    'turkey': 'رئاسة الشؤون الدينية التركية (Diyanet)',
  };

  /// Map of madhab keys to user-friendly Arabic names.
  static const Map<String, String> availableMadhabs = {
    'shafi': 'جمهور العلماء (شافعي، مالكي، حنبلي)',
    'hanafi': 'المذهب الحنفي',
  };

  /// Retrieves the saved method key or defaults to 'auto'.
  static Future<String> getSavedMethodKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyMethod) ?? 'auto';
  }

  /// Saves the selected calculation method key.
  static Future<void> saveMethodKey(String methodKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyMethod, methodKey);
  }

  /// Retrieves the saved madhab key or defaults to 'shafi'.
  static Future<String> getSavedMadhabKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyMadhab) ?? 'shafi';
  }

  /// Saves the selected madhab key.
  static Future<void> saveMadhabKey(String madhabKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyMadhab, madhabKey);
  }

  /// Resolves the [CalculationParameters] based on saved settings and location heuristics.
  static Future<CalculationParameters> resolveCalculationParameters({
    required double latitude,
    required double longitude,
  }) async {
    final methodKey = await getSavedMethodKey();
    final madhabKey = await getSavedMadhabKey();

    CalculationMethod selectedMethod;

    if (methodKey == 'auto') {
      selectedMethod = _autoDetectMethod(latitude, longitude);
    } else {
      selectedMethod = _mapStringToMethod(methodKey);
    }

    final params = selectedMethod.getParameters();

    if (madhabKey == 'hanafi') {
      params.madhab = Madhab.hanafi;
    } else {
      params.madhab = Madhab.shafi;
    }

    return params;
  }

  /// Calculates prayer times for a given location and date.
  /// Returns a map of prayer names in Arabic to local [DateTime] objects.
  static Future<Map<String, DateTime>> calculatePrayerTimes({
    required double latitude,
    required double longitude,
    DateTime? date,
  }) async {
    final targetDate = date ?? DateTime.now();
    final params = await resolveCalculationParameters(
      latitude: latitude,
      longitude: longitude,
    );

    final coordinates = Coordinates(latitude, longitude);
    final dateComponents = DateComponents.from(targetDate);
    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

    return {
      "الفجر": prayerTimes.fajr.toLocal(),
      "الشروق": prayerTimes.sunrise.toLocal(),
      "الظهر": prayerTimes.dhuhr.toLocal(),
      "العصر": prayerTimes.asr.toLocal(),
      "المغرب": prayerTimes.maghrib.toLocal(),
      "العشاء": prayerTimes.isha.toLocal(),
    };
  }

  /// Heuristic auto-detection based on geographical coordinates.
  static CalculationMethod _autoDetectMethod(double lat, double lng) {
    // Saudi Arabia
    if (lat >= 16.0 && lat <= 32.0 && lng >= 34.0 && lng <= 56.0) {
      return CalculationMethod.umm_al_qura;
    }
    // UAE
    if (lat >= 22.0 && lat <= 26.5 && lng >= 51.0 && lng <= 56.5) {
      return CalculationMethod.dubai;
    }
    // Kuwait
    if (lat >= 28.5 && lat <= 30.5 && lng >= 46.5 && lng <= 48.5) {
      return CalculationMethod.kuwait;
    }
    // Qatar
    if (lat >= 24.5 && lat <= 26.5 && lng >= 50.5 && lng <= 51.7) {
      return CalculationMethod.qatar;
    }
    // Turkey
    if (lat >= 35.0 && lat <= 43.0 && lng >= 25.0 && lng <= 45.0) {
      return CalculationMethod.turkey;
    }
    // Egypt & Levant / North Africa
    if (lat >= 15.0 && lat <= 37.0 && lng >= 22.0 && lng <= 36.0) {
      return CalculationMethod.egyptian;
    }
    // North America (USA, Canada, Mexico)
    if (lng <= -50.0 && lng >= -170.0) {
      return CalculationMethod.north_america;
    }
    // South Asia (Pakistan, India, Bangladesh)
    if (lat >= 5.0 && lat <= 37.0 && lng >= 60.0 && lng <= 92.0) {
      return CalculationMethod.karachi;
    }

    // Default neutral fallback for rest of the world
    return CalculationMethod.muslim_world_league;
  }

  /// Maps string key to [CalculationMethod].
  static CalculationMethod _mapStringToMethod(String key) {
    switch (key) {
      case 'egyptian':
        return CalculationMethod.egyptian;
      case 'umm_al_qura':
        return CalculationMethod.umm_al_qura;
      case 'karachi':
        return CalculationMethod.karachi;
      case 'north_america':
        return CalculationMethod.north_america;
      case 'dubai':
        return CalculationMethod.dubai;
      case 'kuwait':
        return CalculationMethod.kuwait;
      case 'qatar':
        return CalculationMethod.qatar;
      case 'turkey':
        return CalculationMethod.turkey;
      case 'muslim_world_league':
      default:
        return CalculationMethod.muslim_world_league;
    }
  }
}
