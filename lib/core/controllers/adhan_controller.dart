import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AdhanController extends GetxController {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _adhanTimer;

  // تهيئة النظام (يجب استدعاؤها مرة واحدة عند تشغيل التطبيق)
  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const InitializationSettings initSettings =
    InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tapped
        // print('Notification tapped! Payload: ${details.payload}');
      },
    );
  }

  // الدالة الرئيسية لجدولة الأذان
  void initializeAdhanScheduling(PrayerTimes prayerTimes) {
    scheduleNextAdhans(prayerTimes); // للتنبيهات الخارجية (System Notifications)
    _startForegroundTimer(prayerTimes); // للتنبيه داخل التطبيق (App Timer)
  }

  // تايمر داخلي يعمل أثناء فتح التطبيق
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
        playAdhan(prayerName);
        // إعادة الجدولة للصلاة التي تليها بعد انتهاء الحالية
        _startForegroundTimer(prayerTimes);
      });
    }
  }

  // تشغيل صوت الأذان وإظهار الواجهة
  Future<void> playAdhan(String prayerName) async {
    try {
      // 1. تحديد المصدر أولاً
      await _audioPlayer.setSource(AssetSource('audio/adhan.mp3'));

      // 2. التشغيل
      await _audioPlayer.resume();

      _showAdhanOverlay(prayerName);
    } catch (e) {
      debugPrint("Error playing adhan audio: $e");
    }
  }
  // إيقاف الأذان وإغلاق الواجهة
  void stopAdhan() {
    _audioPlayer.stop();
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  // جدولة التنبيهات المحلية (تعمل حتى لو التطبيق مغلق)
  Future<void> scheduleNextAdhans(PrayerTimes prayerTimes) async {
    final prayers = {
      'الفجر': prayerTimes.fajr,
      'الظهر': prayerTimes.dhuhr,
      'العصر': prayerTimes.asr,
      'المغرب': prayerTimes.maghrib,
      'العشاء': prayerTimes.isha,
    };

    prayers.forEach((name, time) async {
      if (time.isAfter(DateTime.now())) {
        await scheduleNotification(name, time);
      }
    });
  }

  Future<void> scheduleNotification(String prayerName, DateTime time) async {
    if (time.isBefore(DateTime.now())) {
      debugPrint("تنبيه: تم تجاهل جدولة $prayerName لأن وقتها قد مضى.");
      return; // اخرج من الدالة ولا تقم بالجدولة
    }
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
      // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _showAdhanOverlay(String prayerName) {
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.black.withOpacity(0.8),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1B4332), Color(0xFF081C15)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mosque, size: 100, color: Color(0xFFD4AF37)),
              const SizedBox(height: 30),
              Text(
                "حان الآن موعد أذان $prayerName",
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "حي على الصلاة.. حي على الفلاح",
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 60),
              ElevatedButton.icon(
                onPressed: stopAdhan,
                icon: const Icon(Icons.stop),
                label: const Text("إيقاف الأذان"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      useSafeArea: false,
    );
  }

  String _translate(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr: return 'الفجر';
      case Prayer.dhuhr: return 'الظهر';
      case Prayer.asr: return 'العصر';
      case Prayer.maghrib: return 'المغرب';
      case Prayer.isha: return 'العشاء';
      default: return '';
    }
  }

  @override
  void onClose() {
    _adhanTimer?.cancel();
    _audioPlayer.dispose();
    super.onClose();
  }
}