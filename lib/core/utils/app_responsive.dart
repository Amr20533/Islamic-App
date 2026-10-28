import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Centralised responsive helper.
///
/// Breakpoints:
///   mobile  : width < 600 (and not web)
///   tablet  : width >= 600 (and not web)
///   web     : kIsWeb == true  (any width)
class AppResponsive {
  AppResponsive._();

  static const double _tabletBreak = 600.0;

  // ── Platform helpers ────────────────────────────────────────────────────────
  static bool isMobile(BuildContext context) =>
      !kIsWeb && MediaQuery.sizeOf(context).width < _tabletBreak;

  static bool isTablet(BuildContext context) =>
      !kIsWeb && MediaQuery.sizeOf(context).width >= _tabletBreak;

  static bool isWeb(BuildContext context) => kIsWeb;

  // ── Generic value selector ──────────────────────────────────────────────────
  /// Returns [web] on web, [tablet] on tablet, [mobile] otherwise.
  /// Falls back to the next smaller tier if a value is not provided.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? web,
  }) {
    if (kIsWeb) return web ?? tablet ?? mobile;
    if (MediaQuery.sizeOf(context).width >= _tabletBreak) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  // ── Convenience wrappers ────────────────────────────────────────────────────

  /// Responsive font size (logical pixels — NOT sp-scaled, intentional on web).
  static double fontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? web,
  }) =>
      value<double>(context, mobile: mobile, tablet: tablet, web: web);

  /// Responsive vertical spacing.
  static double h(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? web,
  }) =>
      value<double>(context, mobile: mobile, tablet: tablet, web: web);

  /// Responsive horizontal spacing / width.
  static double w(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? web,
  }) =>
      value<double>(context, mobile: mobile, tablet: tablet, web: web);

  /// Responsive border radius.
  static double r(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? web,
  }) =>
      value<double>(context, mobile: mobile, tablet: tablet, web: web);

  /// Responsive [EdgeInsets].
  static EdgeInsets padding(
    BuildContext context, {
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? web,
  }) =>
      value<EdgeInsets>(context, mobile: mobile, tablet: tablet, web: web);

  // ── Text-style helpers ──────────────────────────────────────────────────────

  /// Returns an adaptive [TextStyle] for page titles / headers.
  ///   mobile 20 · tablet 22 · web 24
  static TextStyle titleStyle(
    BuildContext context, {
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'Tajawal',
      fontSize: fontSize(context, mobile: 20, tablet: 22, web: 24),
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Body text.
  ///   mobile 16 · tablet 17 · web 18
  static TextStyle bodyStyle(
    BuildContext context, {
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'Tajawal',
      fontSize: fontSize(context, mobile: 16, tablet: 17, web: 18),
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Caption / label text.
  ///   mobile 13 · tablet 14 · web 15
  static TextStyle labelStyle(
    BuildContext context, {
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'Tajawal',
      fontSize: fontSize(context, mobile: 13, tablet: 14, web: 15),
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Card / section heading.
  ///   mobile 18 · tablet 19 · web 20
  static TextStyle cardTitleStyle(
    BuildContext context, {
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'Tajawal',
      fontSize: fontSize(context, mobile: 18, tablet: 19, web: 20),
      fontWeight: fontWeight,
      color: color,
    );
  }
}
