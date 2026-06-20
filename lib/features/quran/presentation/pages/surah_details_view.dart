import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/quran/data/models/quran_metadata.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/features/quran/presentation/widgets/surah_details_header.dart';
import 'package:islamic_app/features/quran/presentation/widgets/mushaf_page_widget.dart';
import 'package:islamic_app/features/quran/presentation/widgets/quran_audio_player_widget.dart';

/// Main Quran reading page — displays a PageView of Mushaf pages.
///
/// Handles page navigation, surah/juz metadata updates, and the audio player.
/// The actual page rendering is delegated to [MushafPageWidget].
class SurahDetailsView extends StatefulWidget {
  final String surahName;
  final int? initialPageNumber;

  const SurahDetailsView({
    super.key,
    required this.surahName,
    this.initialPageNumber,
  });

  @override
  State<SurahDetailsView> createState() => _SurahDetailsViewState();
}

class _SurahDetailsViewState extends State<SurahDetailsView> {
  late PageController _pageController;
  int _currentPageNumber = 1;
  String _currentSurahName = '';
  String _currentJuzName = '';
  bool _isInit = false;

  // ── Quran Metadata Helpers ────────────────────────────────────

  int _resolveSurahNumber(String name) {
    final cleanName = name.replaceAll('سورة ', '').trim();
    for (var entry in QuranMetadata.pageToSurah.entries) {
      if (entry.value['surahName'] == cleanName) {
        return entry.value['surahNumber'] as int;
      }
    }
    return 1;
  }

  int _getStartingPageForSurah(int surahNumber) {
    for (var entry in QuranMetadata.pageToSurah.entries) {
      if (entry.value['surahNumber'] == surahNumber) {
        return entry.key;
      }
    }
    return 1;
  }

  int _getJuzNumberForPage(int page) {
    int maxJuz = 1;
    for (var entry in QuranMetadata.juzToSurah.entries) {
      final startPage = entry.value['pageNumber'] as int;
      if (startPage <= page) {
        maxJuz = entry.key;
      }
    }
    return maxJuz;
  }

  String _getJuzName(int juzNum) {
    const List<String> juzNames = [
      "الأول",
      "الثاني",
      "الثالث",
      "الرابع",
      "الخامس",
      "السادس",
      "السابع",
      "الثامن",
      "التاسع",
      "العاشر",
      "الحادي عشر",
      "الثاني عشر",
      "الثالث عشر",
      "الرابع عشر",
      "الخامس عشر",
      "السادس عشر",
      "السابع عشر",
      "الثامن عشر",
      "التاسع عشر",
      "العشرون",
      "الحادي والعشرون",
      "الثاني والعشرون",
      "الثالث والعشرون",
      "الرابع والعشرون",
      "الخامس والعشرون",
      "السادس والعشرون",
      "السابع والعشرون",
      "الثامن والعشرون",
      "التايع والعشرون",
      "الثلاثون",
    ];
    if (juzNum >= 1 && juzNum <= 30) {
      return "الجزء ${juzNames[juzNum - 1]}";
    }
    return "الجزء الأول";
  }

  // ── Build ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final initialSurahNum = _resolveSurahNumber(widget.surahName);
    if (!_isInit) {
      _currentPageNumber =
          widget.initialPageNumber ?? _getStartingPageForSurah(initialSurahNum);
      _pageController = PageController(initialPage: _currentPageNumber - 1);
      _currentJuzName = _getJuzName(_getJuzNumberForPage(_currentPageNumber));
      final meta = QuranMetadata.pageToSurah[_currentPageNumber];
      if (meta != null) {
        _currentSurahName = meta['surahName'];
      }
      context.read<QuranCubit>().loadSurahData(initialSurahNum);
      _isInit = true;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F1),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            SurahDetailsHeader(
              surahName: _currentSurahName,
              juzName: _currentJuzName,
              pageNumber: _currentPageNumber,
              onBackPressed: () => Navigator.pop(context),
            ),

            // ── Quran PageView + Audio Player ──
            Expanded(
              child: BlocBuilder<QuranCubit, QuranState>(
                builder: (context, state) {
                  if (state is QuranLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is QuranLoaded) {
                    return _buildQuranContent(state);
                  }

                  if (state is QuranError) {
                    return Center(child: Text("Error: ${state.message}"));
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Quran page view with overlaid audio player.
  Widget _buildQuranContent(QuranLoaded state) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          reverse: true,
          itemCount: 604,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            final pageNum = index + 1;
            final versesInPage = state.pages[pageNum];

            if (versesInPage == null || versesInPage.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return MushafPageWidget(
              verses: versesInPage,
              pageNumber: pageNum,
            );
          },
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: QuranAudioPlayerWidget(
              reciters: state.reciters,
              onExpanded: () {},
            ),
          ),
        ),
      ],
    );
  }

  /// Update surah/juz metadata when the user swipes to a new page.
  void _onPageChanged(int index) {
    final pageNum = index + 1;
    final metadata = QuranMetadata.pageToSurah[pageNum];
    if (metadata != null) {
      final surahNum = metadata['surahNumber'] as int;
      context.read<QuranCubit>().loadSurahIfNeeded(surahNum);
      setState(() {
        _currentPageNumber = pageNum;
        _currentSurahName = metadata['surahName'];
        _currentJuzName = _getJuzName(_getJuzNumberForPage(pageNum));
      });
    }
  }
}
