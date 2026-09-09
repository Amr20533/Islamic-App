import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  /// Tries to get the current location.
  /// If [openSettingsIfDisabled] is true, opens device GPS settings when location service is disabled.
  static Future<Position?> getCurrentLocation({bool openSettingsIfDisabled = false}) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services (GPS) are enabled on the device
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (kDebugMode) {
        debugPrint('Location services (GPS) are disabled.');
      }
      if (openSettingsIfDisabled) {
        await Geolocator.openLocationSettings();
      }
      return null;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (kDebugMode) {
          debugPrint('Location permissions are denied.');
        }
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (kDebugMode) {
        debugPrint('Location permissions are permanently denied.');
      }
      if (openSettingsIfDisabled) {
        await Geolocator.openAppSettings();
      }
      return null;
    }

    // Get current position
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching position: $e');
      }
      return null;
    }
  }

  static Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
  static Future<bool> openAppSettings() => Geolocator.openAppSettings();
}
