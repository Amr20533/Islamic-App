import 'package:flutter/material.dart';

class SurahDetailsHeader extends StatelessWidget {
  final String surahName;
  final String juzName;
  final int pageNumber;
  final VoidCallback onBackPressed;
  final VoidCallback? onMenuPressed;

  const SurahDetailsHeader({
    super.key,
    required this.surahName,
    required this.juzName,
    required this.pageNumber,
    required this.onBackPressed,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SurahJuzBanner(
            surahName: surahName,
            juzName: juzName,
            pageNumber: pageNumber,
          ),
          _HeaderIconButton(icon: Icons.arrow_forward_ios, onTap: onBackPressed),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F1E8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD4A574), width: 1.5),
        ),
        child: Icon(icon, color: const Color(0xFF2C1C12)),
      ),
    );
  }
}

/// Center banner showing "سورة [name] | الجزء [name] | صفحة [num]".
class _SurahJuzBanner extends StatelessWidget {
  final String surahName;
  final String juzName;
  final int pageNumber;

  const _SurahJuzBanner({
    required this.surahName,
    required this.juzName,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1E8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4A574), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "سورة $surahName",
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'QuranFont',
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1C12),
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 1.5, height: 20, color: const Color(0xFFD4A574)),
          const SizedBox(width: 8),
          Text(
            juzName,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'QuranFont',
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1C12),
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 1.5, height: 20, color: const Color(0xFFD4A574)),
          const SizedBox(width: 8),
          Text(
            '$pageNumber',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'QuranFont',
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B6B4F),
            ),
          ),
        ],
      ),
    );
  }
}
