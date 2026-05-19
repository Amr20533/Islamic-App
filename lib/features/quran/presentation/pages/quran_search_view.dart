import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_search_cubit.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/features/quran/presentation/pages/surah_details_view.dart';

class QuranSearchView extends StatefulWidget {
  const QuranSearchView({super.key});

  @override
  State<QuranSearchView> createState() => _QuranSearchViewState();
}

class _QuranSearchViewState extends State<QuranSearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<QuranSearchCubit>().loadSearchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToSurah(SearchResult result) {
    if (result.surahNumber <= 0) return;
    context.read<QuranCubit>().loadSurahData(result.surahNumber);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurahDetailsView(
          surahName: result.surahName,
          initialPageNumber: result.page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBF9F1),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFBF9F1),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              textDirection: TextDirection.rtl,
              onChanged: (value) {
                context.read<QuranSearchCubit>().search(value);
              },
              decoration: InputDecoration(
                hintText: "ابحث عن سورة أو آية ...",
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    context.read<QuranSearchCubit>().search('');
                  },
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        body: BlocBuilder<QuranSearchCubit, QuranSearchState>(
          builder: (context, state) {
            if (state is QuranSearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuranSearchError) {
              return Center(child: Text('خطأ: ${state.message}'));
            } else if (state is QuranSearchLoaded) {
              final results = state.searchResults;

              if (_searchController.text.isNotEmpty && results.isEmpty) {
                return const Center(
                  child: Text(
                    "لم يتم العثور على نتائج",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              if (results.isEmpty) {
                return const Center(
                  child: Text(
                    "ابدأ بكتابة اسم السورة أو الآية للبحث",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: results.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 24),
                itemBuilder: (context, index) {
                  final result = results[index];

                  return InkWell(
                    onTap: () => _navigateToSurah(result),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: result.isSurah
                                ? AppColors.thirdColor.withValues(alpha: 0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: result.isSurah
                                ? Icon(Icons.menu_book,
                                    color: AppColors.thirdColor)
                                : const Icon(Icons.format_list_numbered,
                                    color: Colors.grey, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.isSurah
                                    ? "سورة ${result.surahName}"
                                    : result.surahName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.thirdTextColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (!result.isSurah &&
                                  result.text != null &&
                                  result.text!.isNotEmpty)
                                Text(
                                  result.text!,
                                  style: const TextStyle(
                                    fontFamily: 'QuranFont',
                                    fontSize: 18,
                                    height: 1.5,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 4),
                              Text(
                                result.isSurah
                                    ? "تبدأ في الصفحة ${result.page ?? '-'}"
                                    : "آية ${result.verseNumber ?? '-'} • صفحة ${result.page ?? '-'}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
