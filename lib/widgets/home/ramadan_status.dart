import 'package:flutter/material.dart';

import '../../services/helpers/ramadan_utils.dart' show RamadanUtils;

class RamadanStatus extends StatelessWidget {
  const RamadanStatus({super.key, required this.day});
  final int day;
  @override
  Widget build(BuildContext context) {

    bool isLastTen = day > 20;
    bool isLaylatAlQadr = RamadanUtils.isWitr(day);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // تغيير اللون إلى الذهبي في الليالي الوترية
        gradient: LinearGradient(
          colors: isLaylatAlQadr
              ? [Color(0xFFB8860B), Color(0xFFDAA520)] // ذهبي
              : [Color(0xFF1E293B), Color(0xFF0F172A)], // كحلي تقني
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: isLaylatAlQadr ? Colors.amber : Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            "اليوم: $day رمضان",
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            RamadanUtils.getDayType(day),
            style: TextStyle(
                color: isLaylatAlQadr ? Colors.white : Colors.cyanAccent,
                fontSize: 16,
                fontFamily: 'Tajawal'
            ),
          ),
          if (isLaylatAlQadr)
            const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}
