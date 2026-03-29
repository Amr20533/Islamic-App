import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:islamic_app/static_files/app_routes.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  // Singleton
  NotificationService._internal();
  static final NotificationService _instance =
  NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Initialize notifications
  Future<void> init() async {
    tz.initializeTimeZones();

    try {
      // 2. Now you can safely get the location name and set it
      final String timeZoneName = await FlutterTimezone.getLocalTimezone()
          .then((info) => info.identifier);

      tz.setLocalLocation(tz.getLocation(timeZoneName));
      print("Local timezone set to: $timeZoneName");
    } catch (e) {
      print("Timezone initialization failed: $e");
      // Fallback so the app doesn't crash
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings =
    InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Request notification permission on Android 13+ devices
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    // Initialize plugin
    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tapped
        // print('Notification tapped! Payload: ${details.payload}');
      },
    );
  }

  // Expose plugin for scheduling / showing notifications
  FlutterLocalNotificationsPlugin get plugin => _notificationsPlugin;


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

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      title: title,
      body: body,
      notificationDetails: details,
      id: id,
      payload: AppRoutes.details
    );
  }
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      tz.local; // Try to access it
    } catch (_) {
      // If it fails, initialize it right now
      tz.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone().then((info) => info.identifier);
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    }

    print("1. Checking permissions...");
    final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    bool? hasPermission = await androidImplementation?.canScheduleExactNotifications();
    print("2. Exact alarm permission: $hasPermission");

    if (hasPermission == false) {
      await androidImplementation?.requestExactAlarmsPermission();
      return;
    }

    // 2. Schedule
    print("3. Scheduling for: $scheduledTime");
    if (scheduledTime.isBefore(DateTime.now())) {
      print("Skipping: $title is in the past");
      return;
    }
    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      // Ensure scheduledDate is always in the future
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_channel_final',
            'Adhan Alerts',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true,
            playSound: true,
            // 👈 أضف هذا السطر للإشارة للملف الموجود في مجلد raw
            sound: RawResourceAndroidNotificationSound('adhan'),
          ),
          iOS: DarwinNotificationDetails(
            sound: 'adhan.aiff', // لنظام iOS يحتاج الملف بصيغة aiff أو caf
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'test_payload'
    );
    print("4. Successfully scheduled!");  }
}
