import 'package:flutter/material.dart';

class TasbeehCounterDisplay extends StatelessWidget {
  final int counter;

  const TasbeehCounterDisplay({
    super.key,
    required this.counter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Text(
      "$counter",
      style: TextStyle(
        fontFamily: 'Tajawal',
        fontSize: 76,
        fontWeight: FontWeight.w400,
        color: isDark ? const Color(0xFFC8A88A) : const Color(0xFF5D483A),
        letterSpacing: 1.2,
      ),
    );
  }
}
