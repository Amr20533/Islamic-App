import 'package:flutter/material.dart';
import 'package:islamic_app/features/azkar/data/models/zikr_item.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/zikr_repetition_indicator.dart';

class ZikrDetailItem extends StatelessWidget {
  final ZikrItem item;
  final int remaining;
  final VoidCallback onTap;

  const ZikrDetailItem({
    super.key,
    required this.item,
    required this.remaining,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "“ ${item.arabicText.trim()} ”",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFFF5F2EE) : const Color(0xFF3D3020),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ZikrRepetitionIndicator(remaining: remaining),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
