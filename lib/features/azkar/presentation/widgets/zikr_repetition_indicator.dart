import 'package:flutter/material.dart';

class ZikrRepetitionIndicator extends StatelessWidget {
  final int remaining;

  const ZikrRepetitionIndicator({
    super.key,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isCompleted = remaining == 0;

    final circleBg = isCompleted
        ? const Color(0xFF7A8C5A).withOpacity(0.2)
        : (isDark
            ? const Color(0xFFC8A88A).withOpacity(0.15)
            : const Color(0xFF6B5040).withOpacity(0.08));

    final circleBorder = isCompleted
        ? const Color(0xFF7A8C5A)
        : (isDark
            ? const Color(0xFFC8A88A).withOpacity(0.5)
            : const Color(0xFF6B5040).withOpacity(0.3));

    final counterText = isDark ? const Color(0xFFF5F2EE) : const Color(0xFF6B5040);
    final hintText = isCompleted
        ? const Color(0xFF7A8C5A)
        : (isDark ? const Color(0xFFB8AEA5) : const Color(0xFF8A7560));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleBg,
            border: Border.all(
              color: circleBorder,
              width: 1.5,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Color(0xFF7A8C5A),
                    size: 32,
                  )
                : Text(
                    "$remaining",
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: counterText,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isCompleted ? "اكتمل التكرار" : "اضغط للعد",
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: hintText,
          ),
        ),
      ],
    );
  }
}
