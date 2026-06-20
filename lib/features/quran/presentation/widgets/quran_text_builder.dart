import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:islamic_app/features/quran/data/models/verse.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';

/// Builds Quran text spans with:
/// - Consistent font sizing for all Arabic text
/// - Red coloring for لفظ الجلالة (Allah's name)
/// - Verse number markers ﴿١﴾ in brown
/// - Tap recognition per verse for popup menus
class QuranTextBuilder {
  /// Base font size for all Quranic text.
  static const double baseFontSize = 22.0;

  /// Line height multiplier for Quranic text.
  static const double baseLineHeight = 2.2;

  /// Font size for verse number markers ﴿١﴾.
  static const double verseNumberFontSize = 20.0;

  /// Regex matching different Arabic forms of "Allah".
  static final RegExp _allahRegex = RegExp(
    r'(ٱللَّهِ|ٱللَّهُ|ٱللَّهَ|لِلَّهِ|لِلَّهُ|لِلَّهَ|اللَّهِ|اللَّهُ|اللَّهَ)',
  );

  /// Build the complete [TextSpan] for a list of verses.
  ///
  /// [selectedVerseNumber] highlights the tapped verse.
  /// [getRecognizer] provides a gesture recognizer for each verse.
  static TextSpan buildPageSpan({
    required List<Verse> verses,
    required int? selectedVerseNumber,
    required GestureRecognizer Function(Verse verse) getRecognizer,
  }) {
    return TextSpan(
      children: verses.map((verse) {
        final isSelected = verse.number == selectedVerseNumber;
        final highlightColor = isSelected ? const Color(0xFFEDE0CD) : null;
        final recognizer = getRecognizer(verse);

        return TextSpan(
          children: [
            ..._buildColoredSpans(
              "${verse.text?['ar']} ",
              highlightColor,
              recognizer,
            ),
            TextSpan(
              text:
                  "﴿${FormatHelper.replaceWithArabicNumbers(verse.number.toString())}﴾ ",
              recognizer: recognizer,
              style: TextStyle(
                fontSize: verseNumberFontSize,
                height: baseLineHeight,
                color: const Color(0xFF8B4513),
                fontFamily: 'QuranFont',
                backgroundColor: highlightColor,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  /// Split [text] into spans, coloring Allah's name in red.
  static List<TextSpan> _buildColoredSpans(
    String text,
    Color? highlightColor,
    GestureRecognizer recognizer,
  ) {
    final matches = _allahRegex.allMatches(text);

    if (matches.isEmpty) {
      return [
        _quranSpan(
          text: text,
          color: Colors.black,
          highlightColor: highlightColor,
          recognizer: recognizer,
        ),
      ];
    }

    int currentIndex = 0;
    final List<TextSpan> spans = [];

    for (final match in matches) {
      // Text before "Allah"
      if (match.start > currentIndex) {
        spans.add(_quranSpan(
          text: text.substring(currentIndex, match.start),
          color: Colors.black,
          highlightColor: highlightColor,
          recognizer: recognizer,
        ));
      }

      // "Allah" — same size, red color
      spans.add(_quranSpan(
        text: text.substring(match.start, match.end),
        color: Colors.red,
        highlightColor: highlightColor,
        recognizer: recognizer,
      ));

      currentIndex = match.end;
    }

    // Text after last "Allah"
    if (currentIndex < text.length) {
      spans.add(_quranSpan(
        text: text.substring(currentIndex),
        color: Colors.black,
        highlightColor: highlightColor,
        recognizer: recognizer,
      ));
    }

    return spans;
  }

  /// Create a single Quran-styled [TextSpan].
  static TextSpan _quranSpan({
    required String text,
    required Color color,
    required Color? highlightColor,
    required GestureRecognizer recognizer,
  }) {
    return TextSpan(
      text: text,
      recognizer: recognizer,
      style: TextStyle(
        fontSize: baseFontSize,
        height: baseLineHeight,
        fontFamily: 'QuranFont',
        color: color,
        backgroundColor: highlightColor,
      ),
    );
  }
}
