import 'package:flutter/material.dart';

class TasbeehCounterDisplay extends StatelessWidget {
  final int counter;

  const TasbeehCounterDisplay({
    super.key,
    required this.counter,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "$counter",
      style: const TextStyle(
        fontFamily: 'Tajawal',
        fontSize: 76,
        fontWeight: FontWeight.w400,
        color: Color(0xFF5D483A),
        letterSpacing: 1.2,
      ),
    );
  }
}
