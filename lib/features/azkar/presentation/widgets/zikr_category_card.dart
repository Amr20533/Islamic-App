import 'package:flutter/material.dart';

class ZikrCategoryCard extends StatelessWidget {
  final String title;
  final Color textColor;
  final String backgroundImage;
  final String iconImage;
  final double iconSize;
  final double fontSize;
  final VoidCallback? onTap;

  const ZikrCategoryCard({
    super.key,
    required this.title,
    required this.backgroundImage,
    required this.iconImage,
    this.textColor = const Color(0xFF5C4A2A),
    this.iconSize = 72,
    this.fontSize = 17,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 162,
        height: 186.5,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.25,
                  child: Image.asset(backgroundImage, fit: BoxFit.cover),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    iconImage,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      title,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Tajawal',
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
