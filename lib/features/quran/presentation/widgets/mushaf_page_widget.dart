import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/features/quran/data/models/verse.dart';
import 'package:islamic_app/features/quran/data/services/quran_bookmark_service.dart';
import 'package:islamic_app/features/quran/presentation/widgets/mushaf_frame_painter.dart';
import 'package:islamic_app/features/quran/presentation/widgets/verse_popup_menu.dart';
import 'package:islamic_app/features/quran/presentation/widgets/quran_text_builder.dart';
import 'package:islamic_app/features/quran/presentation/widgets/tafsir_bottom_sheet.dart';
import 'package:islamic_app/features/quran/presentation/widgets/translation_bottom_sheet.dart';
import 'package:islamic_app/features/quran/presentation/widgets/verse_audio_bottom_sheet.dart';
import 'package:islamic_app/features/quran/presentation/pages/quran_view.dart';

/// A single Quran page in the Mushaf style.
///
/// Displays the verses for one page with:
/// - Surah start indicator (if applicable)
/// - Quranic text with tappable verses
/// - Verse popup menu on tap
/// - Page number at bottom
class MushafPageWidget extends StatefulWidget {
  final List<Verse> verses;
  final int pageNumber;

  const MushafPageWidget({
    super.key,
    required this.verses,
    required this.pageNumber,
  });

  @override
  State<MushafPageWidget> createState() => _MushafPageWidgetState();
}

class _MushafPageWidgetState extends State<MushafPageWidget> {
  int? _selectedVerseNumber;
  final VersePopupMenu _popupMenu = VersePopupMenu();
  final Map<int, TapGestureRecognizer> _recognizers = {};

  @override
  void dispose() {
    _popupMenu.dismiss();
    for (final recognizer in _recognizers.values) {
      recognizer.dispose();
    }
    _recognizers.clear();
    super.dispose();
  }

  // ── Verse Tap Handling ──────────────────────────────────────────

  void _handleVerseTap(Verse verse, Offset tapPosition) {
    if (_selectedVerseNumber == verse.number) {
      setState(() => _selectedVerseNumber = null);
      _popupMenu.dismiss();
    } else {
      setState(() => _selectedVerseNumber = verse.number);
      _popupMenu.show(
        context: context,
        tapPosition: tapPosition,
        verse: verse,
        onDismiss: () => setState(() => _selectedVerseNumber = null),
        onAction: _handleVerseAction,
      );
    }
  }

  void _handleVerseAction(VerseAction action, Verse verse) async {
    if (action == VerseAction.tafseer) {
      TafsirBottomSheet.show(context, verse);
      return;
    }
    if (action == VerseAction.translation) {
      TranslationBottomSheet.show(context, verse);
      return;
    }
    if (action == VerseAction.listen) {
      VerseAudioBottomSheet.show(context, verse);
      return;
    }
    if (action == VerseAction.bookmark) {
      final prefs = locator<SharedPreferences>();
      final bookmark = QuranBookmark(
        surahNumber: verse.surahNumber ?? 1,
        verseNumber: verse.number ?? 1,
        surahName: verse.surahNameAr ?? '',
        pageNumber: verse.page,
        verseText: verse.text?['ar'] ?? '',
      );
      final success = await QuranBookmarkService.addBookmark(bookmark, prefs);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? "تمت إضافة الآية للمفضلة بنجاح 🌱" : "الآية مضافة بالفعل في المفضلة ✨",
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }
    if (action == VerseAction.lastRead) {
      final prefs = locator<SharedPreferences>();
      await prefs.setString('last_read_surah_name', verse.surahNameAr ?? '');
      await prefs.setInt('last_read_page_number', verse.page);
      await prefs.setInt('last_read_verse_number', verse.number ?? 1);
      await prefs.setInt('last_read_surah_number', verse.surahNumber ?? 1);

      // تحديث الـ ValueNotifier في الفهرس
      QuranLastReadHelper.update(verse.surahNameAr ?? '', verse.page);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "تم حفظ علامة القراءة: سورة ${verse.surahNameAr} آية ${verse.number} 🌱",
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }
    if (action == VerseAction.share) {
      final surahName = verse.surahNameAr ?? '';
      final verseNum = verse.number ?? 1;
      final verseText = verse.text?['ar'] ?? '';

      final shareText = 'قال تعالى:\n\n'
          '« $verseText »\n\n'
          '[سورة $surahName - آية $verseNum]';

      await Share.share(shareText);
      return;
    }
  }

  TapGestureRecognizer _getRecognizerForVerse(Verse verse) {
    final verseNum = verse.number ?? 0;
    if (!_recognizers.containsKey(verseNum)) {
      _recognizers[verseNum] = TapGestureRecognizer()
        ..onTapDown = (TapDownDetails details) {
          _handleVerseTap(verse, details.globalPosition);
        };
    }
    return _recognizers[verseNum]!;
  }

  @override
  Widget build(BuildContext context) {
    int totalCharacters = 0;
    for (var v in widget.verses) {
      totalCharacters += (v.text?['ar'] as String?)?.length ?? 0;
    }

    final hasStartOfSurah = widget.verses.any((v) => v.number == 1);

    return MushafPageFrame(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          children: [
            // Surah start spacer
            if (hasStartOfSurah) ...[const SizedBox(height: 4)],

            // Quran text
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text.rich(
                    textAlign: totalCharacters < 400
                        ? TextAlign.center
                        : TextAlign.justify,
                    QuranTextBuilder.buildPageSpan(
                      verses: widget.verses,
                      selectedVerseNumber: _selectedVerseNumber,
                      getRecognizer: _getRecognizerForVerse,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
