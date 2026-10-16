import 'dart:math' as math;
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/core/services/helpers/location_helper.dart';

/// Calculates the Qibla (direction to Mecca) based on the user's GPS location.
class QiblaService {
  // Kaaba coordinates
  static const double _kaabaLat = 21.4225;
  static const double _kaabaLng = 39.8262;

  /// Returns the Qibla bearing in degrees (0-360) from True North,
  /// or null if the location is unavailable.
  static Future<double?> getQiblaBearing() async {
    final Position? position = await LocationHelper.getCurrentLocation(
      openSettingsIfDisabled: true,
    );
    if (position == null) return null;

    final coordinates = Coordinates(position.latitude, position.longitude);
    final qiblaDirection = Qibla(coordinates);
    return qiblaDirection.direction;
  }

  /// Calculates bearing manually from user coords to Kaaba using the
  /// haversine / forward-azimuth formula (fallback if adhan unavailable).
  static double calculateBearingTo({
    required double fromLat,
    required double fromLng,
  }) {
    final double lat1 = fromLat * math.pi / 180;
    final double lat2 = _kaabaLat * math.pi / 180;
    final double dLng = (_kaabaLng - fromLng) * math.pi / 180;

    final double y = math.sin(dLng) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);

    final double bearing = math.atan2(y, x) * 180 / math.pi;
    return (bearing + 360) % 360;
  }
}
