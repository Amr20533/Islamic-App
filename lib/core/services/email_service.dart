import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailService {
  static const String recipientEmail = 'maab.app01@gmail.com';
  static const String bugReportSubject = "Bug Report - Ma'ab";
  static const String feedbackSubject = "Feedback - Ma'ab";

  /// Sends a bug report via email using the device's mail app.
  /// Returns `true` if the email app opened successfully, `false` otherwise.
  static Future<bool> sendBugReport({
    required String problemType,
    required String problemDescription,
  }) async {
    final appVersion = await _getAppVersion();
    final androidVersion = await _getAndroidVersion();
    final deviceModel = await _getDeviceModel();
    final currentTime = DateTime.now().toString();

    final body = '''
نوع المشكلة / Problem Type: $problemType

وصف المشكلة / Problem Description:
$problemDescription

----------------------------------------
معلومات الجهاز والتطبيق:
إصدار التطبيق / App Version: $appVersion
إصدار الأندرويد / Android Version: $androidVersion
طراز الجهاز / Device Model: $deviceModel
الوقت الحالي / Current Time: $currentTime
''';

    return _sendEmail(subject: bugReportSubject, body: body);
  }

  /// Sends app feedback via email using the device's mail app.
  /// Returns `true` if the email app opened successfully, `false` otherwise.
  static Future<bool> sendFeedback({
    required String feedbackText,
  }) async {
    final appVersion = await _getAppVersion();
    final androidVersion = await _getAndroidVersion();
    final deviceModel = await _getDeviceModel();
    final currentTime = DateTime.now().toString();

    final body = '''
الملاحظات والتعليق / Feedback:
$feedbackText

----------------------------------------
معلومات الجهاز والتطبيق:
إصدار التطبيق / App Version: $appVersion
إصدار الأندرويد / Android Version: $androidVersion
طراز الجهاز / Device Model: $deviceModel
الوقت الحالي / Current Time: $currentTime
''';

    return _sendEmail(subject: feedbackSubject, body: body);
  }

  static Future<bool> _sendEmail({
    required String subject,
    required String body,
  }) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: recipientEmail,
        queryParameters: {'subject': subject, 'body': body},
      );

      if (await canLaunchUrl(emailUri)) {
        return await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback: Attempt launching directly in case canLaunchUrl returned false due to system queries restriction
        return await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (_) {
      return false;
    }
  }

  static Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version}+${packageInfo.buildNumber}';
    } catch (_) {
      return 'Unknown';
    }
  }

  static Future<String> _getAndroidVersion() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        return '${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
      }
      return Platform.operatingSystem;
    } catch (_) {
      return 'Unknown';
    }
  }

  static Future<String> _getDeviceModel() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        return iosInfo.utsname.machine;
      }
      return 'Unknown';
    } catch (_) {
      return 'Unknown';
    }
  }
}
