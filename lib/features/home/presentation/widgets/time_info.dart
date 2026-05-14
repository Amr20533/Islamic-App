import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';

class TimeInfo extends StatelessWidget {
  const TimeInfo({super.key, required this.label, required this.time});
  final String label;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    // final String localizedTime = FormatHelper.replaceWithArabicNumbers(FormatHelper.formatTime12Hour(time));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          FormatHelper.replaceWithArabicNumbers(
            FormatHelper.formatTime12Hour(time),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
