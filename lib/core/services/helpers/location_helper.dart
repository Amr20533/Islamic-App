import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (kDebugMode) {
        debugPrint('Location services are disabled.');
      }

      return null; // Return null instead of throwing
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
      return null;
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
