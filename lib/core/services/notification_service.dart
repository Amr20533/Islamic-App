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
    'وردك القرآني بانتظارك، افتح مآب وأكمل من حيث توقفت 📖',
    'لا تجعل يومك يمضي دون أن تنور قلبك بآيات من القرآن، افتح مآب الآن 🌱',
    'صفحة واحدة من المصحف قد تكفي لإضاءة يومك، افتح مآب وأكمل وردك 🕊️',
    'هل صليت على النبي اليوم؟ اللهم صلِّ وسلم على نبينا محمد ﷺ',
    'استعن بالله ولا تعجز، وردك القرآني بانتظارك 🌿',
    "قال تعالى: 'ألا بذكر الله تطمئن القلوب'.. اذكر الله ✨",
    'دقائق قليلة مع كتاب الله تمنحك طمأنينة لا تنتهي، افتح مآب وأكمل قراءتك 📖',
    'خطوة صغيرة اليوم تقربك أكثر، افتح مآب وأكمل رحلتك 🚀',
    'الاستغفار يفتح مغاليق الخير، أستغفر الله العظيم وأتوب إليه 🌿',
    'جدد نيتك وافتح المصحف الآن لقراءة وردك اليومي 📖',
    'خير الأعمال أدومها وإن قل، لا تنسَ قراءة وردك اليوم 🌸',
    'نصف ساعة من وقتك للقرآن قد تغير مجرى يومك بالكامل 💚',
    'تذكر أن القرآن شفيع لأصحابه يوم القيامة، افتح مآب واقرأ آياتك 🕊️',
    'لا تؤجل وردك اليومي، ابدأ الآن واقرأ ما تيسر من القرآن 📖',
    'سبحان الله وبحمده، سبحان الله العظيم.. جدد لسانك بذكر الله 💫',
    'قال رسول الله ﷺ: «من قرأ حرفاً من كتاب الله فله به حسنة».. افتح مآب واكسب الحسنات 🌿',
    'هون عليك، فالقليل المستمر خير من الكثير المنقطع',
    'ساعة إجابة أو لحظة تدبر قد تغير حياتك، افتح مآب واذكر ربك 🤍',
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

  /// Whether [init] has completed successfully.
  bool get isInitialized => _initialized;

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
    } catch (e) {
      // Cannot determine device timezone — keep the default system local.
      // Do NOT hardcode Africa/Cairo or tz.UTC as a fallback.
      debugPrint('⚠️ Could not detect timezone: $e — using system default');
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
  /// If [prayerTime] is in the past, schedules for the next day automatically.
  Future<void> schedulePrayerNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
  }) async {
    await cancelNotification(id);

    var scheduledTime = tz.TZDateTime.from(prayerTime, tz.local);
    final now = tz.TZDateTime.now(tz.local);

    // If the prayer time has already passed today, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
      debugPrint(
        '⏭ Prayer time passed — rescheduled to tomorrow: $scheduledTime',
      );
    }

    await _schedule(
      id: id,
      title: 'حان وقت صلاة $prayerName 🕌',
      body: 'حي على الصلاة، حي على الفلاح',
      at: scheduledTime,
      details: _prayerDetails,
    );
  }

  /// Schedule a test Adhan notification [seconds] into the future.
  /// Used for manual testing of alarm, notification, and sound playback.
  Future<void> scheduleTestNotification({int seconds = 10}) async {
    const testId = 9999;
    await cancelNotification(testId);

    final testTime = tz.TZDateTime.now(
      tz.local,
    ).add(Duration(seconds: seconds));

    await _schedule(
      id: testId,
      title: 'اختبار الأذان التجريبي 🕌',
      body: 'حي على الصلاة، حي على الفلاح - نجاح تجربة الأذان والصوت',
      at: testTime,
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

  /// Schedule multiple daily motivational notifications at specific hours.
  /// Each notification gets a unique ID (base 300+index).
  /// Cancels any previously scheduled reminders in the same slot range.
  ///
  /// Example: [8, 13, 18] schedules at 8:00, 13:00, and 18:00 every day.
  Future<void> scheduleMultipleDailyReminders(List<int> hours) async {
    // Cancel old reminders in the slots 300-319
    for (int i = 300; i < 320; i++) {
      await cancelNotification(i);
    }

    final now = tz.TZDateTime.now(tz.local);

    for (int i = 0; i < hours.length; i++) {
      final hour = hours[i];
      var target = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        0,
      );
      if (target.isBefore(now)) target = target.add(const Duration(days: 1));

      await _schedule(
        id: 300 + i,
        title: 'تذكيرك الإسلامي 🌿',
        body: await _nextMessage(),
        at: target,
        details: _defaultDetails,
        recurring: DateTimeComponents.time,
      );
      debugPrint('📅 Scheduled daily reminder #$i at $hour:00');
    }
    debugPrint('✅ ${hours.length} daily reminders scheduled at hours: $hours');
  }

  /// Schedule a custom daily repeating reminder at a specific hour and minute.
  /// Uses [DateTimeComponents.time] so it repeats automatically every day at the given time.
  Future<void> scheduleDailyCustomReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    await cancelNotification(id);

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
      id: id,
      title: title,
      body: body,
      at: target,
      details: _defaultDetails,
      recurring: DateTimeComponents.time,
      payload: payload,
    );
    debugPrint(
      '⏰ Scheduled daily reminder "$title" (id=$id) at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
    );
  }

  /// Schedule the standard Islamic daily reminders throughout the day:
  /// 1. أذكار الصباح (07:00 AM)
  /// 2. صلاة الضحى (10:30 AM)
  /// 3. أذكار المساء (05:00 PM)
  /// 4. ورد القرآن اليومي (09:00 PM)
  /// 5. صلاة الوتر وأذكار النوم (11:00 PM)
  Future<void> scheduleIslamicDailyReminders() async {
    // 1. Morning Azkar (07:00 AM)
    await scheduleDailyCustomReminder(
      id: 401,
      title: 'أذكار الصباح ☀️',
      body: 'أصبحنا وأصبح الملك لله.. حان وقت أذكار الصباح لحفظك وبركة يومك 🌿',
      hour: 7,
      minute: 0,
      payload: 'azkar_morning',
    );

    // 2. Duha Prayer (10:30 AM)
    await scheduleDailyCustomReminder(
      id: 402,
      title: 'صلاة الضحى ☀️',
      body: 'صلاة الأوابين.. ركعتان تجزئ عن 360 صدقة فلا تفوت أجرها ✨',
      hour: 10,
      minute: 30,
      payload: 'duha_prayer',
    );

    // 3. Evening Azkar (05:00 PM)
    await scheduleDailyCustomReminder(
      id: 403,
      title: 'أذكار المساء 🌙',
      body: 'أمسينا وأمسى الملك لله.. حصّن نفسك وأهلك بأذكار المساء 🕊️',
      hour: 17,
      minute: 0,
      payload: 'azkar_evening',
    );

    // 4. Daily Quran (09:00 PM)
    await scheduleDailyCustomReminder(
      id: 404,
      title: 'وردك القرآني اليومي ',
      body:
          'دقائق قليلة مع كتاب الله تمنحك طمأنينة لا تنتهي.. افتح مآب واقرأ وردك ',
      hour: 21,
      minute: 0,
      payload: 'quran_reading',
    );

    // 5. Witr Prayer & Sleep Azkar (11:00 PM)
    await scheduleDailyCustomReminder(
      id: 405,
      title: 'صلاة الوتر وأذكار النوم ',
      body: 'أوتر ولو بركعة واختم يومك بذكر الله.. باسمك ربي وضعت جنبي ',
      hour: 23,
      minute: 0,
      payload: 'sleep_azkar',
    );

    debugPrint('✅ All 5 Islamic daily reminders scheduled successfully');
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
    String? payload,
  }) async {
    // Guard: skip only if still in the past after caller adjustments
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
        payload: payload,
      );
      debugPrint(
        '✅ Scheduled id=$id at $at (exact: $exact, recurring: ${recurring != null})',
      );
    } catch (e) {
      debugPrint('❌ zonedSchedule failed id=$id: $e');
      if (exact) {
        try {
          await _plugin.zonedSchedule(
            id: id,
            title: title,
            body: body,
            scheduledDate: at,
            notificationDetails: details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: recurring,
            payload: payload,
          );
          debugPrint('⚠️ Retry with inexact succeeded for id=$id');
        } catch (retryError) {
          debugPrint('❌ zonedSchedule retry failed id=$id: $retryError');
        }
      }
    }
  }

  // ── Notification Details ─────────────────────────────────────────────────────

  static final _prayerDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
      'prayer_channel_final',
      'Adhan Alerts',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan'),
      audioAttributesUsage: AudioAttributesUsage.notification,
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
