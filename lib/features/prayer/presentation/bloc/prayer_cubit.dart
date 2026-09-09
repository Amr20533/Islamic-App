import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/helpers/location_helper.dart';
import 'package:islamic_app/core/services/prayer_calculation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'prayer_state.dart';

class PrayerCubit extends Cubit<PrayerState> {
  double? latitude;
  double? longitude;
  Timer? _timer;
  bool _isCalculating = false;

  // Cached prayer data — recalculated only when location/settings change
  // or when the next prayer time passes.
  Map<String, DateTime>? _cachedTodayPrayers;
  String? _nextPrayerName;
  DateTime? _nextPrayerTime;

  PrayerCubit({this.latitude, this.longitude}) : super(PrayerInitial()) {
    init();
  }

  Future<void> init() async {
    emit(PrayerLoading());

    // 1. Try to read from SharedPreferences if coordinates were not provided
    if (latitude == null || longitude == null) {
      final prefs = await SharedPreferences.getInstance();
      latitude = prefs.getDouble('last_lat');
      longitude = prefs.getDouble('last_lng');
    }

    // 2. Try to get device location via LocationHelper if still null
    if (latitude == null || longitude == null) {
      final position = await LocationHelper.getCurrentLocation();
      if (position != null) {
        latitude = position.latitude;
        longitude = position.longitude;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('last_lat', latitude!);
        await prefs.setDouble('last_lng', longitude!);
      }
    }

    await _recalculate();
    _startTimer();
  }

  /// Manually trigger location refresh (e.g. from UI button).
  Future<void> refreshLocation() async {
    emit(PrayerLoading());
    final position = await LocationHelper.getCurrentLocation(openSettingsIfDisabled: true);
    if (position != null) {
      latitude = position.latitude;
      longitude = position.longitude;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('last_lat', latitude!);
      await prefs.setDouble('last_lng', longitude!);
      await _recalculate();
    } else {
      emit(const PrayerError('خدمات الموقع (GPS) مغلقة أو الإذن غير مفعل. يرجى تفعيل الموقع من إعدادات الجهاز وإعادة المحاولة.'));
    }
  }

  /// Saves new calculation settings (method + madhab) and recalculates.
  Future<void> updateCalculationSettings(
    String methodKey,
    String madhabKey,
  ) async {
    _timer?.cancel();
    _timer = null;

    emit(PrayerLoading());
    await PrayerCalculationService.saveMethodKey(methodKey);
    await PrayerCalculationService.saveMadhabKey(madhabKey);
    await _recalculate();
    _startTimer();
  }

  /// Updates coordinates when the device location changes.
  void updateLocation(double lat, double lng) {
    if (latitude != null &&
        longitude != null &&
        (latitude! - lat).abs() < 0.01 &&
        (longitude! - lng).abs() < 0.01) {
      return; // Movement too small to matter
    }
    latitude = lat;
    longitude = lng;
    init();
  }

  /// Full async recalculation via PrayerCalculationService.
  Future<void> _recalculate() async {
    if (latitude == null || longitude == null) {
      emit(
        const PrayerError('يرجى تفعيل خدمات الموقع (GPS) لحساب مواقيت الصلاة'),
      );
      return;
    }
    if (_isCalculating) return;
    _isCalculating = true;
    try {
      final todayPrayers = await PrayerCalculationService.calculatePrayerTimes(
        latitude: latitude!,
        longitude: longitude!,
      );

      final now = DateTime.now();
      final fivePrayers = <String, DateTime>{
        "الفجر": todayPrayers["الفجر"]!,
        "الظهر": todayPrayers["الظهر"]!,
        "العصر": todayPrayers["العصر"]!,
        "المغرب": todayPrayers["المغرب"]!,
        "العشاء": todayPrayers["العشاء"]!,
      };

      final futurePrayers =
          fivePrayers.entries
              .where((e) => e.value.isAfter(now))
              .toList()
            ..sort((a, b) => a.value.compareTo(b.value));

      if (futurePrayers.isNotEmpty) {
        _nextPrayerName = futurePrayers.first.key;
        _nextPrayerTime = futurePrayers.first.value;
      } else {
        // After Isha — next prayer is tomorrow's Fajr
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final tomorrowPrayers =
            await PrayerCalculationService.calculatePrayerTimes(
              latitude: latitude!,
              longitude: longitude!,
              date: tomorrow,
            );
        _nextPrayerName = "الفجر";
        _nextPrayerTime = tomorrowPrayers["الفجر"]!;
      }

      _cachedTodayPrayers = todayPrayers;
      _emitCurrent();
    } catch (e) {
      emit(PrayerError(e.toString()));
    } finally {
      _isCalculating = false;
    }
  }

  /// Emits current state using cached data (fast — no async work).
  void _emitCurrent() {
    if (_cachedTodayPrayers == null ||
        _nextPrayerName == null ||
        _nextPrayerTime == null) {
      return;
    }
    emit(
      PrayerLoaded(
        nextPrayerName: _nextPrayerName!,
        nextPrayerTime: _nextPrayerTime!,
        countdown: _calculateCountdown(_nextPrayerTime!),
        todayPrayers: _cachedTodayPrayers!,
      ),
    );
  }

  /// Starts a 1-second timer that updates the countdown display.
  /// Only triggers a full recalculation when the next prayer time passes.
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_nextPrayerTime != null &&
          DateTime.now().isAfter(_nextPrayerTime!)) {
        // The next prayer has passed — recalculate to find the new next one
        _recalculate();
      } else {
        // Just update the countdown string (no async work)
        _emitCurrent();
      }
    });
  }

  String _calculateCountdown(DateTime nextTime) {
    final diff = nextTime.difference(DateTime.now());
    if (diff.isNegative) return '00:00:00';
    final h = diff.inHours.toString().padLeft(2, '0');
    final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
