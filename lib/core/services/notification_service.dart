import 'dart:async';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

enum NotificationPermissionStatus {
  unknown,
  granted,
  notificationsDenied,
  exactAlarmDenied,
}

class NotificationService {
  // Singleton
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  // ── Constants ───────────────────────────────────────────────────────────────

  static const String prayerChannelId = 'prayer_channel_final';
  static const String defaultChannelId = 'default_channel';
  static const int dailyReminderId = 123;

  static const _messages = [
    'هل صليت على النبي اليوم؟',
    'استعن بالله ولا تعجز، وردك القرآني بانتظارك.',
    "قال تعالى: 'ألا بذكر الله تطمئن القلوب'.. اذكر الله.",
    'نصف ساعة من وقتك للقرآن قد تغير مجرى يومك بالكامل.',
    'خطوة صغيرة اليوم قد تقربك أكثر، افتح مآب وأكمل رحلتك.',
    "لا تأجل عمل اليوم للغد، فقد يفتنك التسويف.",
    "هون عليك، فالقليل المستمر خير من الكثير المنقطع.",
    'الاستغفار يفتح مغاليق الخير، استغفر ربك.',
    "الدنيا دار ممر لا دار مقر",
    "من كان يؤمن بالله واليوم الآخر فليقل خيراً أو ليصمت",
    "يا ابن آدم، عش ما شئت فإنك ميت، وأحبب من شئت فإنك مفارقه، واعمل ما شئت فإنك مجازى به.",
    "خير الأعمال أدومها وإن قل.",
    "وَقُل رَّبِّ زِدْنِي عِلْمًا",
    "قال تعالى: 'وَفِي ذَٰلِكَ فَلْيَتَنَافَسِ الْمُتَنَافِسُونَ'",
  ];

  // ── State ───────────────────────────────────────────────────────────────────

  final _plugin = FlutterLocalNotificationsPlugin();
  final _permissionStream =
      StreamController<NotificationPermissionStatus>.broadcast();

  Stream<NotificationPermissionStatus> get permissionStatusStream =>
      _permissionStream.stream;
  NotificationPermissionStatus get permissionStatus => _permissionStatus;
  NotificationPermissionStatus _permissionStatus =
      NotificationPermissionStatus.unknown;

  bool _initialized = false;

  // ── Init ─────────────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;

    try {
      // 1. Timezone
      tz_data.initializeTimeZones();
      await _initTimezone();

      // 2. Plugin initialize (must come before any resolvePlatformSpecificImplementation call)
      final ok = await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          ),
        ),
        onDidReceiveNotificationResponse: _onTap,
        onDidReceiveBackgroundNotificationResponse: _onBackgroundTap,
      );
      if (ok != true) return;

      // 3. Channels (must exist before showing any notification on Android 8+)
      await _createChannels();

      // 4. Permissions (after initialize so resolvePlatformSpecificImplementation works)
      await _requestPermissions();

      _initialized = true;
      debugPrint('✅ NotificationService initialized');
    } catch (e) {
      debugPrint('❌ NotificationService.init: $e');
    }
  }

  Future<void> _initTimezone() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
      debugPrint('📍 Timezone: ${info.identifier}');
    } catch (_) {
      try {
        tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
      } catch (_) {
        tz.setLocalLocation(tz.UTC);
      }
    }
  }

  Future<void> _createChannels() async {
    final android = _android;
    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        prayerChannelId,
        'Adhan Alerts',
        description: 'تنبيهات مواقيت الصلاة والأذان',
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('adhan'),
      ),
    );

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        defaultChannelId,
        'Default Notifications',
        description: 'تنبيهات التذكير اليومي والرسائل التحفيزية',
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
      ),
    );
  }

  Future<void> _requestPermissions() async {
    final android = _android;
    if (android == null) return;

    final notif = await android.requestNotificationsPermission(); // Android 13+
    final exact = await android.requestExactAlarmsPermission(); // Android 12+
    _setPermissionStatus(notif, exact);
  }

  // ── Public Permission API ────────────────────────────────────────────────────

  /// Re-check permissions when the app resumes (user may have changed Settings).
  Future<void> onAppResumed() async {
    final android = _android;
    if (android == null) return;
    _setPermissionStatus(
      await android.areNotificationsEnabled(),
      await android.canScheduleExactNotifications(),
    );
  }

  /// Whether the OS allows exact alarms right now.
  Future<bool> canScheduleExact() async {
    if (!Platform.isAndroid) return true;
    return await _android?.canScheduleExactNotifications() ?? false;
  }

  // ── Scheduling ───────────────────────────────────────────────────────────────

  /// Schedule a prayer (Adhan) notification.
  /// Cancels any existing alarm with the same [id] first.
  Future<void> schedulePrayerNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
  }) async {
    await cancelNotification(id);
    await _schedule(
      id: id,
      title: 'حان وقت صلاة $prayerName 🕌',
      body: 'حي على الصلاة، حي على الفلاح',
      at: tz.TZDateTime.from(prayerTime, tz.local),
      details: _prayerDetails,
    );
  }

  /// Schedule (or re-schedule) the daily motivational reminder.
  /// Uses [DateTimeComponents.time] so it recurs every day and survives reboots.
  Future<void> scheduleDailyReminderAt({
    required int hour,
    required int minute,
  }) async {
    await cancelNotification(dailyReminderId);

    final now = tz.TZDateTime.now(tz.local);
    var target = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (target.isBefore(now)) target = target.add(const Duration(days: 1));

    await _schedule(
      id: dailyReminderId,
      title: 'تذكيرك اليومي 🌿',
      body: await _nextMessage(),
      at: target,
      details: _defaultDetails,
      recurring: DateTimeComponents.time,
    );
  }

  /// Show an instant (non-scheduled) notification.
  Future<void> showNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) => _plugin.show(
    id: id,
    title: title,
    body: body,
    notificationDetails: _defaultDetails,
    payload: payload,
  );

  // ── Cancellation ─────────────────────────────────────────────────────────────

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id: id);
    debugPrint('🗑 Cancelled notification $id');
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
    debugPrint('🗑 All notifications cancelled');
  }

  // ── Battery Optimization ─────────────────────────────────────────────────────

  /// Ask the OS to whitelist this app from battery optimization.
  /// Only shows once; stores the flag in SharedPreferences.
  Future<void> requestBatteryOptimizationExemption({
    required String packageName,
  }) async {
    if (!Platform.isAndroid) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('battery_opt_requested') == true) return;

      await AndroidIntent(
        action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
        data: 'package:$packageName',
      ).launch();

      await prefs.setBool('battery_opt_requested', true);
    } catch (e) {
      debugPrint('⚠️ Battery optimization request failed: $e');
    }
  }

  // ── Core Scheduler ───────────────────────────────────────────────────────────

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime at,
    required NotificationDetails details,
    DateTimeComponents? recurring,
  }) async {
    // Skip past one-shot notifications
    if (recurring == null && at.isBefore(tz.TZDateTime.now(tz.local))) {
      debugPrint('⚠️ Skipping past notification id=$id ($at)');
      return;
    }

    // Choose exact vs inexact based on current OS permission
    final exact = await canScheduleExact();
    if (!exact) {
      debugPrint('⚠️ Exact alarms unavailable for id=$id — using inexact');
      _permissionStream.add(NotificationPermissionStatus.exactAlarmDenied);
    }

    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: at,
        notificationDetails: details,
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: recurring,
      );
      debugPrint(
        '✅ Scheduled id=$id at $at (exact: $exact, recurring: ${recurring != null})',
      );
    } catch (e) {
      debugPrint('❌ zonedSchedule failed id=$id: $e');
    }
  }

  // ── Notification Details ─────────────────────────────────────────────────────

  static final _prayerDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
      'prayer_channel_final',
      'Adhan Alerts',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan'),
      enableVibration: true,
    ),
    iOS: DarwinNotificationDetails(
      sound: 'adhan.aiff',
      presentAlert: true,
      presentSound: true,
    ),
  );

  static final _defaultDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      importance: Importance.max,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
  );

  // ── Helpers ──────────────────────────────────────────────────────────────────

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  void _setPermissionStatus(bool? notifications, bool? exact) {
    _permissionStatus = notifications == false
        ? NotificationPermissionStatus.notificationsDenied
        : exact == false
        ? NotificationPermissionStatus.exactAlarmDenied
        : NotificationPermissionStatus.granted;
    _permissionStream.add(_permissionStatus);
  }

  Future<String> _nextMessage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final i = prefs.getInt('motivational_index') ?? 0;
      await prefs.setInt('motivational_index', i + 1);
      return _messages[i % _messages.length];
    } catch (_) {
      return _messages[0];
    }
  }

  // ── Tap Handlers ─────────────────────────────────────────────────────────────

  static void _onTap(NotificationResponse r) =>
      debugPrint('🔔 Notification tapped: id=${r.id}, payload=${r.payload}');

  @pragma('vm:entry-point')
  static void _onBackgroundTap(NotificationResponse r) =>
      debugPrint('🔔 Background notification tapped: id=${r.id}');

  void dispose() => _permissionStream.close();
}
