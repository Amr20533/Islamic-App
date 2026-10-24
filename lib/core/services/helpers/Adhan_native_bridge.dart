import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Talks to the native AlarmScheduler/PlaybackService — real background
/// Adhan audio, interrupts other apps' music via audio focus, has a Stop
/// button. Separate from NotificationService, which only handles the
/// text-based "approaching" reminder and doesn't need native code.
class AdhanNativeBridge {
  static const MethodChannel _channel = MethodChannel('com.maab.islamic_app/adhan');

  /// [id] should match the same key you use elsewhere for this prayer
  /// (e.g. PrayerAlarmConfig.key) so toggling/cancelling stays consistent.
  Future<DateTime?> sync({
    required String id,
    required bool enabled,
    required TimeOfDay time,
    required String label,
  }) async {
    final millis = await _channel.invokeMethod<int>('sync', {
      'id': id,
      'enabled': enabled,
      'hour': time.hour,
      'minute': time.minute,
      'label': label,
    });
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<void> playNow({String id = 'test'}) async {
    await _channel.invokeMethod('playNow', {'id': id});
  }

  Future<void> stop() async {
    await _channel.invokeMethod('stop');
  }
}