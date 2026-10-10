import 'package:flutter/material.dart';

class SurahBanner extends StatelessWidget {
  const SurahBanner({super.key, required this.surahName});
  final String surahName;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName =
        surahName.startsWith('سورة') ? surahName : 'سورة $surahName';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242220) : const Color(0xFFF7F4EC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF383430) : const Color(0xFFE2D6C5),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "۞",
            style: TextStyle(
              fontSize: 16,
              color: isDark ? const Color(0xFFC8A88A) : const Color(0xFF8B6B4F),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'QuranFont',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFC8A88A) : const Color(0xFF765B43),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "۞",
            style: TextStyle(
              fontSize: 16,
              color: isDark ? const Color(0xFFC8A88A) : const Color(0xFF8B6B4F),
            ),
          ),
        ],
      ),
    );
  }
}
