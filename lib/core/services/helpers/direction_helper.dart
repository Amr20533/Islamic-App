import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Helper class for handling RTL/LTR direction-aware icons and alignments.
class DirectionHelper {
  DirectionHelper._();

  /// Known RTL language codes.
  static const _rtlLanguages = {'ar', 'he', 'fa', 'ur', 'ps', 'ku', 'sd'};

  /// Whether the device's locale is a right-to-left language.
  static bool get isDeviceRtl {
    final locale = ui.PlatformDispatcher.instance.locale;
    return _rtlLanguages.contains(locale.languageCode);
  }

  /// Returns the appropriate back-arrow icon based on the device locale.
  /// - RTL devices → right-pointing arrow (→)
  /// - LTR devices → left-pointing arrow (←)
  static IconData get backArrowIcon =>
      isDeviceRtl ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded;

  /// Returns the alignment for a back button based on the device locale.
  /// - RTL devices → right side
  /// - LTR devices → left side
  static Alignment get backButtonAlignment =>
      isDeviceRtl ? Alignment.centerRight : Alignment.centerLeft;
}
