import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:timezone/data/latest_all.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  final List<String> motivationalMessages = [
    "هل صليت على النبي اليوم؟",
    "استعن بالله ولا تعجز، وردك القرآني بانتظارك.",
    "قال تعالى: 'ألا بذكر الله تطمئن القلوب'.. اذكر الله.",
    "نصف ساعة من وقتك للقرآن قد تغير مجرى يومك بالكامل.",
  ];

  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int dailyReminderId = 123;

  /// تهيئة الإشعارات والمناطق الزمنية
  Future<void> init() async {
    try {
      tzData.initializeTimeZones();
      await _initTimeZone();

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // طلب الصلاحية للأندرويد
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint('Notification clicked: ${details.payload}');
        },
      );

      // إنشاء القنوات
      await _createChannels();

      debugPrint('✅ NotificationService initialized');
    } catch (e) {
      debugPrint('❌ Notification init error: $e');
    }
  }

  Future<void> _initTimeZone() async {
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = timezoneInfo.identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint('📍 Timezone set to: $timeZoneName');
    } catch (e) {
      debugPrint('⚠️ Timezone detect failed: $e. Defaulting to UTC.');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  Future<void> _createChannels() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    try {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'prayer_channel_final',
          'Adhan Alerts',
          description: 'تنبيهات مواقيت الصلاة والأذان',
          importance: Importance.max,
          enableVibration: true,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('adhan'),
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'default_channel',
          'Default Notifications',
          description: 'تنبيهات التذكير اليومي والرسائل التحفيزية',
          importance: Importance.max,
          enableVibration: true,
          playSound: true,
        ),
      );
    } catch (e) {
      debugPrint('❌ Channel creation error: $e');
    }
  }

  Future<void> scheduleDailyReminders() async {
    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(minutes: 2));

    debugPrint("--- Final Test Debug ---");
    debugPrint("Now: ${tz.TZDateTime.now(tz.local)}");
    debugPrint("Target: $scheduledDate");
    debugPrint("------------------------");

    await _safeZonedSchedule(
      id: dailyReminderId,
      title: 'رسالة تحفيزية',
      body: motivationalMessages[1],
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'Default Notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        ),
      ),
    );
    debugPrint("Scheduled for 2 minutes from now!");
  }

  /// جدولة تذكير يومي في وقت محدد (تستدعى من ProfileCubit)
  Future<void> scheduleDailyReminderAt({
    required int hour,
    required int minute,
  }) async {
    await cancelNotification(dailyReminderId);

    final now = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _safeZonedSchedule(
      id: dailyReminderId,
      title: 'تذكيرك اليومي 🌿',
      body: motivationalMessages[2],
      scheduledDate: scheduledTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'Default Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// جدولة إشعار صلاة (تستدعى من PrayerAlarmCubit)
  Future<void> schedulePrayerNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
  }) async {
    await scheduleNotification(
      id: id,
      title: 'حان وقت صلاة $prayerName 🕌',
      body: 'حي على الصلاة، حي على الفلاح',
      scheduledTime: prayerTime,
    );
  }

  /// جدولة إشعار عام
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

    await _safeZonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_channel_final',
          'Adhan Alerts',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('adhan'),
        ),
        iOS: DarwinNotificationDetails(sound: 'adhan.aiff'),
      ),
    );
  }

  /// جدولة إشعار آمن للتعامل مع permissions الأندرويد
  Future<void> _safeZonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    try {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: matchDateTimeComponents,
      );
      debugPrint('✅ Exact notification $id scheduled for $scheduledDate');
    } catch (e) {
      debugPrint('⚠️ Exact failed, trying inexact: $e');
      try {
        await _notificationsPlugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: matchDateTimeComponents,
        );
        debugPrint('✅ Inexact notification $id scheduled');
      } catch (innerE) {
        try {
          await _notificationsPlugin.zonedSchedule(
            id: id,
            title: title,
            body: body,
            scheduledDate: scheduledDate,
            notificationDetails: notificationDetails,
            matchDateTimeComponents: matchDateTimeComponents,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          );
          debugPrint('✅ Basic notification $id scheduled');
        } catch (finalE) {
          debugPrint('❌ All schedule methods failed: $finalE');
        }
      }
    }
  }

  /// عرض إشعار فوري
  Future<void> showNotification({
    required int id,
    String? title,
    String? body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'Default Notifications',
          channelDescription: 'General notifications',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: AppRoutes.details,
    );
  }

  /// إلغاء إشعار بمعرّفه
  Future<void> cancel(int id) async {
    await _notificationsPlugin.cancel(id: id);
    debugPrint('✅ Notification $id cancelled');
  }

  /// إلغاء إشعار بمعرّفه (الدالة القديمة)
  Future<void> cancelNotification(int id) async {
    await cancel(id);
  }

  /// إلغاء جميع الإشعارات
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
    debugPrint('✅ All notifications cancelled');
  }
}
