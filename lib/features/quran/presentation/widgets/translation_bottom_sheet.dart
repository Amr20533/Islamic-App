import 'package:flutter/material.dart';
import 'package:islamic_app/features/quran/data/models/verse.dart';

/// Bottom sheet displaying the English translation for a specific [Verse].
class TranslationBottomSheet extends StatelessWidget {
  final Verse verse;

  const TranslationBottomSheet({super.key, required this.verse});

  /// Utility method to show the bottom sheet.
  static void show(BuildContext context, Verse verse) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TranslationBottomSheet(verse: verse),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surahName = verse.surahNameAr ?? '';
    final verseNum = verse.number ?? 1;
    final verseTextAr = verse.text?['ar'] ?? '';
    final translationTextEn =
        verse.text?['en'] ?? 'No translation available for this verse.';

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFBF9F1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 15, spreadRadius: 2),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: FractionallySizedBox(
        heightFactor: 0.6, // Takes up 60% of the screen height
        child: Column(
          children: [
            // Drag handle indicator
            const SizedBox(height: 12),
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD4A574).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF2C1C12)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'ترجمة الآية (English)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: Color(0xFF3E2723),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'سورة $surahName - آية $verseNum',
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE5D5C5), height: 1),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Verse Text Display Card (Arabic)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F1E8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFD4A574).withValues(alpha: 0.6),
                          width: 1.2,
                        ),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          verseTextAr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'QuranFont',
                            color: Color(0xFF2C1C12),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title for translation section
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Translation:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Translation Text Display Card (English - LTR)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE5D5C5),
                          width: 1.0,
                        ),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          translationTextEn,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF3E2723),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
