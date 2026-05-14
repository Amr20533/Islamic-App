import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adhan/adhan.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'adhan_event.dart';
import 'adhan_state.dart';

class AdhanBloc extends Bloc<AdhanEvent, AdhanState> {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _adhanTimer;

  AdhanBloc() : super(AdhanInitial()) {
    on<AdhanInitializeEvent>(_onInitialize);
    on<AdhanScheduleEvent>(_onSchedule);
    on<AdhanPlayEvent>(_onPlay);
    on<AdhanStopEvent>(_onStop);
  }

  Future<void> _onInitialize(
    AdhanInitializeEvent event,
    Emitter<AdhanState> emit,
  ) async {
    emit(AdhanLoading());
    try {
      tz.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosSettings = DarwinInitializationSettings();

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (details) {
          // Handle notification tapped
        },
      );
      emit(AdhanIdle());
    } catch (e) {
      emit(AdhanError(e.toString()));
    }
  }

  Future<void> _onSchedule(
    AdhanScheduleEvent event,
    Emitter<AdhanState> emit,
  ) async {
    final prayerTimes = event.prayerTimes;

    // System Notifications
    final prayers = {
      'الفجر': prayerTimes.fajr,
      'الظهر': prayerTimes.dhuhr,
      'العصر': prayerTimes.asr,
      'المغرب': prayerTimes.maghrib,
      'العشاء': prayerTimes.isha,
    };

    for (var entry in prayers.entries) {
      if (entry.value.isAfter(DateTime.now())) {
        await _scheduleNotification(entry.key, entry.value);
      }
    }

    // Foreground Timer
    _startForegroundTimer(prayerTimes);
  }

  void _startForegroundTimer(PrayerTimes prayerTimes) {
    _adhanTimer?.cancel();

    final nextPrayer = prayerTimes.nextPrayer();
    if (nextPrayer == Prayer.none) return;

    final prayerName = _translate(nextPrayer);
    final prayerTime = prayerTimes.timeForPrayer(nextPrayer);

    if (prayerTime == null) return;

    final duration = prayerTime.difference(DateTime.now());

    if (!duration.isNegative) {
      _adhanTimer = Timer(duration, () {
        add(AdhanPlayEvent(prayerName));
        _startForegroundTimer(prayerTimes);
      });
    }
  }

  Future<void> _onPlay(AdhanPlayEvent event, Emitter<AdhanState> emit) async {
    try {
      await _audioPlayer.setSource(AssetSource('audio/adhan.mp3'));
      await _audioPlayer.resume();
      emit(AdhanPlaying(event.prayerName));
    } catch (e) {
      debugPrint("Error playing adhan audio: $e");
    }
  }

  Future<void> _onStop(AdhanStopEvent event, Emitter<AdhanState> emit) async {
    await _audioPlayer.stop();
    emit(AdhanIdle());
  }

  Future<void> _scheduleNotification(String prayerName, DateTime time) async {
    await _notifications.zonedSchedule(
      id: time.hashCode,
      title: 'حان الآن موعد أذان $prayerName',
      body: 'حي على الصلاة، حي على الفلاح',
      scheduledDate: tz.TZDateTime.from(time, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'adhan_channel_id',
          'الأذان',
          channelDescription: 'تنبيهات مواقيت الصلاة',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('adhan'),
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'adhan.aiff',
          presentAlert: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  String _translate(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      default:
        return '';
    }
  }

  @override
  Future<void> close() {
    _adhanTimer?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
