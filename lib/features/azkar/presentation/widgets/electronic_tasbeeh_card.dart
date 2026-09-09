import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class ElectronicTasbeehCard extends StatefulWidget {
  final VoidCallback onTap;
  const ElectronicTasbeehCard({super.key, required this.onTap});

  @override
  State<ElectronicTasbeehCard> createState() => _ElectronicTasbeehCardState();
}

class _ElectronicTasbeehCardState extends State<ElectronicTasbeehCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 135,
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
              // 1. Decorative background overlay pattern
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

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22.0,
                  vertical: 16.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "المسبحة الإلكترونية",
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? const Color(0xFFF5F2EE)
                                  : AppColors.thirdTextColor,
                            ),
                          ),
                          Text(
                            "عداد حر للتسبيح والذكر\nسبّح في أي وقت وبكل ما تشاء",
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 13,
                              color: isDark
                                  ? const Color(0xFFB8AEA5)
                                  : AppColors.primaryTextColor.withOpacity(0.65),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 145,
                      height: 162,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: Image.asset('assets/images/download (1) 1.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
