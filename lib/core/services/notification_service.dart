import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  // 1. قائمة الرسائل المحفزة
  final List<String> motivationalMessages = [
    "هل صليت على النبي اليوم؟",
    "استعن بالله ولا تعجز، وردك القرآني بانتظارك.",
    "قال تعالى: 'ألا بذكر الله تطمئن القلوب'.. اذكر الله.",
    "نصف ساعة من وقتك للقرآن قد تغير مجرى يومك بالكامل.",
  ];

  // Singleton pattern
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// وظيفة لجدولة تنبيهات يومية (للتجربة الساعة 11 مساءً)
  Future<void> scheduleDailyReminders() async {
    await _notificationsPlugin.zonedSchedule(
      id: 999,
      title: 'تذكير يومي',
      body: motivationalMessages[0],
      scheduledDate: _nextInstanceOfElevenPM(),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// حساب التوقيت القادم للساعة 11 مساءً
  tz.TZDateTime _nextInstanceOfElevenPM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      23,
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// Initialize notifications
  Future<void> init() async {
    tz.initializeTimeZones();

    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone().then(
        (info) => info.identifier,
      );
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

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

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  /// Simple test notification
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

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      tz.local;
    } catch (_) {
      tz.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone().then(
        (info) => info.identifier,
      );
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    }

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    bool? hasPermission = await androidImplementation
        ?.canScheduleExactNotifications();

    if (hasPermission == false) {
      await androidImplementation?.requestExactAlarmsPermission();
      return;
    }

    if (scheduledTime.isBefore(DateTime.now())) {
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
