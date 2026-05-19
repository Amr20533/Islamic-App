import 'package:flutter/material.dart';

class SurahBanner extends StatelessWidget {
  const SurahBanner({super.key, required this.surahName});
  final String surahName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/surah_banner_frame.png'), // إذا كان لديك إطار زخرفي
          fit: BoxFit.fill,
        ),
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
      ),
      child: Text(
        "سورة $surahName",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'QuranFont',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }
}
