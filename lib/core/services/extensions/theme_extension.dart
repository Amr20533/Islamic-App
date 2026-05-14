import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  // Shortcut to the full ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Shortcut to TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Specific color shortcuts for your AppColors mapped in the scheme
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get tertiaryColor => colorScheme.tertiary; // Your AppColors.thirdColor

  // Custom semantic access for your specific black/grey needs
  Color get surfaceColor => colorScheme.surface;
  Color get outlineColor => colorScheme.outline;

  // High-level text color access
  Color get primaryTextColor => colorScheme.onSurface;
  Color get secondaryTextColor => colorScheme.onTertiary;

  // Custom Shadow helper (Using the 18% opacity logic from earlier)
  List<BoxShadow> get softShadow => [
    BoxShadow(
      color: const Color(0x2E000000), // 18% Black
      offset: const Offset(0, 0),
      blurRadius: 32,
      spreadRadius: 0,
    ),
  ];
}
