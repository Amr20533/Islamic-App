import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
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

  Future<void> scheduleDailyReminders() async {
    // جدولة التنبيه بعد دقيقتين من الآن بالضبط
    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(minutes: 2));

    print("--- Final Test Debug ---");
    print("Now: ${tz.TZDateTime.now(tz.local)}");
    print("Target: $scheduledDate");
    print("------------------------");

    await _notificationsPlugin.zonedSchedule(
      id: 123,
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    print("Scheduled for 2 minutes from now!");
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> init() async {
    tz.initializeTimeZones();

    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone().then(
        (info) => info.identifier,
      );
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      print("Timezone set to: $timeZoneName");
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

    // تنبيه فوري للتأكد
    await showNotification(
      id: 0,
      title: "نظام التنبيهات",
      body: "تم تفعيل نظام التنبيهات بنجاح!",
    );
  }

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
