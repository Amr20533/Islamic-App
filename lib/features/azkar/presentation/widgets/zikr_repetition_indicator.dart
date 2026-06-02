import 'package:flutter/material.dart';

class ZikrRepetitionIndicator extends StatelessWidget {
  final int remaining;

  const ZikrRepetitionIndicator({
    super.key,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = remaining == 0;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? const Color(0xFF7A8C5A).withOpacity(0.1)
                : const Color(0xFF6B5040).withOpacity(0.08),
            border: Border.all(
              color: isCompleted
                  ? const Color(0xFF7A8C5A)
                  : const Color(0xFF6B5040).withOpacity(0.3),
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
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B5040),
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
            color: isCompleted
                ? const Color(0xFF7A8C5A)
                : const Color(0xFF8A7560),
          ),
        ),
      ],
    );
  }
}
