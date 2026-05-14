import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/quran/data/models/verse.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';

class SurahDetailsView extends StatelessWidget {
  final String surahName;
  const SurahDetailsView({super.key, required this.surahName});

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

            if (pageNumbers.isEmpty) {
              return const Center(child: Text("لا توجد بيانات لهذه السورة"));
            }

            return PageView.builder(
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
    return Column(
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text.rich(
                  textAlign: TextAlign.justify,
                  _buildTextSpan(verses),
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
              fontSize: 16,
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
            TextSpan(
              text: "${v.text?['ar']} ",
              style: const TextStyle(
                fontSize: 24,
                height: 2.2,
                fontFamily: 'QuranFont',
                color: Colors.black,
              ),
            ),
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
}
