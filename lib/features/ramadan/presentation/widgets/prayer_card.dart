import 'package:flutter/material.dart';

class PrayerCard extends StatelessWidget {
  final String title;
  final String time;
  final Color color;
  final Color textColor;

  const PrayerCard({
    super.key,
    required this.title,
    required this.time,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            time,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
