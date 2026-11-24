import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class ElectronicTasbeehCard extends StatelessWidget {
  final VoidCallback onTap;
  const ElectronicTasbeehCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 165,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF282522), const Color(0xFF1E1C1A)]
                  : [const Color(0xFFF7F3EE), const Color(0xFFEEE5DB)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.2)
                    : const Color(0xFF8B6B4F).withOpacity(0.08),
                blurRadius: 18,
                spreadRadius: -2,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: isDark
                  ? const Color(0xFF383430)
                  : Colors.white.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // 1. خلفية زخرفية
                Positioned.fill(
                  child: Opacity(
                    opacity: isDark ? 0.08 : 0.18,
                    child: Image.asset(
                      'assets/images/bg_pattern.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),

                // 2. صورة اليد والسبحة على اليسار مطابقة للتصميم بدقة عالية
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/tasbeeh_card_hand.png',
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.centerLeft,
                  ),
                ),

                // 3. النصوص على اليمين
                Align(
                  alignment: Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.55,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 22),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "المسبحة الإلكترونية",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? const Color(0xFFF5F2EE)
                                  : AppColors.thirdTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "عداد حر للتسبيح والذكر",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFFB8AEA5)
                                  : const Color(0xFF8C735D),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "سبّح في أي وقت وبكل ما تشاء",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFFB8AEA5)
                                  : const Color(0xFF8C735D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
