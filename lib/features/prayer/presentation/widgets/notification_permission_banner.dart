import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Compact permission reminder banner that displays a slim, non-intrusive
/// container (low height) if prayer notifications, exact alarms, or battery optimization
/// exemption need to be enabled.
class NotificationPermissionBanner extends StatefulWidget {
  const NotificationPermissionBanner({super.key});

  @override
  State<NotificationPermissionBanner> createState() =>
      _NotificationPermissionBannerState();
}

class _NotificationPermissionBannerState
    extends State<NotificationPermissionBanner>
    with WidgetsBindingObserver {
  static const _batteryChannel = MethodChannel('com.maab.islamic_app/battery');

  bool _notificationsEnabled = true;
  bool _exactAlarmsAllowed = true;
  bool _isBatteryExempt =
      true; // true means Unrestricted/Ignoring optimizations
  bool _sessionDismissed = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cleanupOldPermanentDismissal();
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  /// Removes old permanent dismissal flag so the banner can appear again.
  Future<void> _cleanupOldPermanentDismissal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('permission_banner_dismissed')) {
        await prefs.remove('permission_banner_dismissed');
      }
    } catch (_) {}
  }

  Future<void> _checkPermissions() async {
    if (!Platform.isAndroid) {
      if (mounted) setState(() => _loaded = true);
      return;
    }

    final plugin = FlutterLocalNotificationsPlugin();
    final android = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final notif = await android?.areNotificationsEnabled() ?? true;
    final exact = await android?.canScheduleExactNotifications() ?? true;
    final batteryExempt = await _checkBatteryOptimizationExempt();

    debugPrint(
      '🔍 [PermissionBanner] notifEnabled=$notif, exactAllowed=$exact, batteryExempt=$batteryExempt',
    );

    if (mounted) {
      setState(() {
        _notificationsEnabled = notif;
        _exactAlarmsAllowed = exact;
        _isBatteryExempt = batteryExempt;
        _loaded = true;
      });
    }
  }

  Future<bool> _checkBatteryOptimizationExempt() async {
    try {
      final bool? isIgnoring = await _batteryChannel.invokeMethod<bool>(
        'isIgnoringBatteryOptimizations',
      );
      if (isIgnoring != null) {
        debugPrint(
          '🔋 [PermissionBanner] Native isIgnoringBatteryOptimizations: $isIgnoring',
        );
        return isIgnoring;
      }
    } catch (e) {
      debugPrint(
        '⚠️ [PermissionBanner] Native channel not ready (hot-reload): $e',
      );
    }

    // Fallback: If native channel isn't ready or failed, check if user already verified it
    final prefs = await SharedPreferences.getInstance();
    final reviewed = prefs.getBool('battery_optimization_reviewed') ?? false;
    // If not reviewed yet, treat as not exempt so the banner shows for the user
    return reviewed;
  }

  Future<void> _handleAction() async {
    final plugin = FlutterLocalNotificationsPlugin();
    final android = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (!_notificationsEnabled) {
      await android?.requestNotificationsPermission();
    } else if (!_exactAlarmsAllowed) {
      await android?.requestExactAlarmsPermission();
    } else if (!_isBatteryExempt) {
      await _openBatteryOptimizationSettings();
    }
    await _checkPermissions();
  }

  Future<void> _openBatteryOptimizationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('battery_optimization_reviewed', true);

    // 1. Try native method channel
    try {
      final ok = await _batteryChannel.invokeMethod<bool>(
        'requestIgnoreBatteryOptimizations',
      );
      if (ok == true) return;
    } catch (_) {}

    // 2. Direct intent for request ignore battery optimizations
    try {
      const intent = AndroidIntent(
        action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
        data: 'package:com.maab.islamic_app',
      );
      await intent.launch();
      return;
    } catch (_) {}

    // 3. Fallback: battery optimization settings list
    try {
      const intent = AndroidIntent(
        action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
      );
      await intent.launch();
      return;
    } catch (_) {}

    // 4. Fallback: application details
    try {
      const intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:com.maab.islamic_app',
      );
      await intent.launch();
    } catch (_) {}
  }

  void _dismissForSession() {
    setState(() => _sessionDismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _sessionDismissed) return const SizedBox.shrink();

    // If all permissions and battery exemptions are active, hide container completely
    if (_notificationsEnabled && _exactAlarmsAllowed && _isBatteryExempt) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String message;
    final IconData icon;

    if (!_notificationsEnabled) {
      message = 'تفعيل الإشعارات ليصلك صوت الأذان في وقته';
      icon = Icons.notifications_active_outlined;
    } else if (!_exactAlarmsAllowed) {
      message = 'تفعيل التنبيه الدقيق لضمان توقيت الأذان الصحيح';
      icon = Icons.alarm_on_rounded;
    } else {
      // Battery is restricted/optimized
      message = 'توفير البطارية مقيّد، اضغط للسماح بالعمل في الخلفية';
      icon = Icons.battery_alert_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A231C) : const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF4A3E31) : AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Small Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.counterColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.counterColor, size: 18),
          ),
          const SizedBox(width: 10),

          // Message (Single compact line)
          Expanded(
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFFF5F2EE)
                    : AppColors.primaryTextColor,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Compact Action Button
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.counterColor,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _handleAction,
            child: const Text(
              'تفعيل',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 4),

          // Dismiss Button (X) - Dismisses for this session
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _dismissForSession,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: isDark
                    ? const Color(0xFFB8AEA5)
                    : AppColors.hintTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
