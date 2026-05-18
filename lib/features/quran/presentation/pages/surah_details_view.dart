import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/quran/data/models/verse.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/features/quran/presentation/widgets/quran_audio_player_widget.dart';

class SurahDetailsView extends StatelessWidget {
  final String surahName;
  final int? initialPageNumber;
  const SurahDetailsView({super.key, required this.surahName, this.initialPageNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F1),
      appBar: AppBar(
        title: Text(surahName, style: const TextStyle(fontFamily: 'QuranFont')),
        centerTitle: true,
        backgroundColor: const Color(0xFFFBF9F1),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          if (state is QuranLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QuranLoaded) {
            final pageNumbers = state.sortedPageNumbers;
            final reciters = state.reciters;

            if (pageNumbers.isEmpty) {
              return const Center(child: Text("لا توجد بيانات لهذه السورة"));
            }

            int initialIndex = 0;
            if (initialPageNumber != null) {
              initialIndex = pageNumbers.indexOf(initialPageNumber!);
              if (initialIndex == -1) initialIndex = 0;
            }

            final pageController = PageController(initialPage: initialIndex);

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: PageView.builder(
                    controller: pageController,
                    reverse: true,
                    itemCount: pageNumbers.length,
                    itemBuilder: (context, index) {
                      final pageNum = pageNumbers[index];
                      final versesInPage = state.pagesInCurrentSurah[pageNum]!;

                      return MushafPageWidget(
                        verses: versesInPage,
                        pageNumber: pageNum,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: QuranAudioPlayerWidget(
                      reciters: reciters,
                      onExpanded: () {},
                    ),
                  ),
                ),
              ],
            );
          }

          if (state is QuranError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class MushafPageWidget extends StatelessWidget {
  final List<Verse> verses;
  final int pageNumber;

  const MushafPageWidget({
    super.key,
    required this.verses,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    // حساب عدد الحروف في الصفحة لمعرفة ما إذا كانت صفحة قصيرة (مثل الفاتحة أو أول البقرة)
    int totalCharacters = 0;
    for (var v in verses) {
      totalCharacters += (v.text?['ar'] as String?)?.length ?? 0;
    }
    // إضافة مسافة فقط للصفحات القصيرة
    final double horizontalPadding = totalCharacters < 400 ? 16.0 : 0.0;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: SizedBox(
                width:
                    MediaQuery.of(context).size.width - (horizontalPadding * 2),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text.rich(
                    textAlign: totalCharacters < 400
                        ? TextAlign.center
                        : TextAlign.justify,
                    _buildTextSpan(verses),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            FormatHelper.replaceWithArabicNumbers(pageNumber.toString()),
            style: TextStyle(
              fontSize: 10,
              color: Colors.brown.withOpacity(0.7),
              fontFamily: 'QuranFont',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  TextSpan _buildTextSpan(List<Verse> verses) {
    return TextSpan(
      children: verses.map((v) {
        return TextSpan(
          children: [
            ..._getColoredSpans("${v.text?['ar']} "),
            TextSpan(
              text:
                  "﴿${FormatHelper.replaceWithArabicNumbers(v.number.toString())}﴾ ",
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF8B4513),
                fontFamily: 'QuranFont',
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  List<TextSpan> _getColoredSpans(String text) {
    final regex = RegExp(
      r'(ٱللَّهِ|ٱللَّهُ|ٱللَّهَ|لِلَّهِ|لِلَّهُ|لِلَّهَ|اللَّهِ|اللَّهُ|اللَّهَ)',
    );
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return [
        TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 24,
            height: 2.2,
            fontFamily: 'QuranFont',
            color: Colors.black,
          ),
        ),
      ];
    }

    int currentIndex = 0;
    List<TextSpan> spans = [];

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
            style: const TextStyle(
              fontSize: 24,
              height: 2.2,
              fontFamily: 'QuranFont',
              color: Colors.black,
            ),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: const TextStyle(
            fontSize: 24,
            height: 2.2,
            fontFamily: 'QuranFont',
            color: Colors.red, // The colored word
          ),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: const TextStyle(
            fontSize: 24,
            height: 2.2,
            fontFamily: 'QuranFont',
            color: Colors.black,
          ),
        ),
      );
    }

    return spans;
  }
}
