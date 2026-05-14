import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:islamic_app/features/home/presentation/widgets/card_placeholder.dart';
import 'package:islamic_app/features/home/presentation/widgets/time_info.dart';
import 'package:islamic_app/core/services/helpers/ramadan_service.dart';

class IftarCountdownCard extends StatefulWidget {
  final PrayerTimes? prayerTimes;

  const IftarCountdownCard({super.key, this.prayerTimes});

  @override
  State<IftarCountdownCard> createState() => _IftarCountdownCardState();
}

class _IftarCountdownCardState extends State<IftarCountdownCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && widget.prayerTimes != null) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Handle the Null/Loading State
    if (widget.prayerTimes == null) {
      return const CardPlaceholder();
    }

    // 2. Handle the Data State
    final times = widget.prayerTimes!;
    final now = DateTime.now();

    // Calculate Progress
    final totalFastingDuration = times.maghrib.difference(times.fajr).inSeconds;
    final remainingSeconds = times.maghrib.difference(now).inSeconds;
    // Progress goes from 0.0 (Fajr) to 1.0 (Iftar)
    double progress =
        1.0 - (remainingSeconds / totalFastingDuration).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "الوقت المتبقي للإفطار",
            style: TextStyle(
              color: Color(0xFF38BDF8),
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            RamadanService.getCountdownToIftar(times),
            style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              // Background Track
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Animated Progress
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                height: 10,
                width: MediaQuery.of(context).size.width * 0.7 * progress,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF38BDF8), Color(0xFF818CF8)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TimeInfo(label: "Fajr", time: times.fajr),
              TimeInfo(label: "Maghrib", time: times.maghrib),
            ],
          ),
        ],
      ),
    );
  }
}
