import 'package:flutter/material.dart';

class AppShadows {
  static const Color secondaryTextColor = Color(0xFF3E2F25);

  static const List<BoxShadow> customShadow = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 2),
      blurRadius: 4.0,
      spreadRadius: -5.45,
    ),
  ];

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x29000000),
      offset: Offset(0, 2),
      blurRadius: 8.0,
      spreadRadius:0,
    ),
  ];

  static const List<BoxShadow> softCenteredGlow = [
    BoxShadow(
      color: Color(0x0000002E),
      offset: Offset(0, 0),
      blurRadius: 32.0,
      spreadRadius: 0.0,
    ),
  ];

}
