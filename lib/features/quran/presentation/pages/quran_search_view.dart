import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_search_cubit.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';

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
    Navigator.pushNamed(
      context,
      AppRoutes.surahDetails,
      arguments: {
        'surahName': result.surahName,
        'initialPageNumber': result.page,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? const Color(0xFFF5F2EE) : Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Container(
            height: 45,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF211F1D) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? const Color(0xFF383430) : AppColors.borderColor,
              ),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: isDark ? const Color(0xFFF5F2EE) : Colors.black,
              ),
              onChanged: (value) {
                context.read<QuranSearchCubit>().search(value);
              },
              decoration: InputDecoration(
                hintText: "ابحث عن سورة أو آية ...",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFFB8AEA5) : Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? const Color(0xFFC8A88A) : Colors.grey,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: isDark ? const Color(0xFFB8AEA5) : Colors.grey,
                    size: 20,
                  ),
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
                return Center(
                  child: Text(
                    "لم يتم العثور على نتائج",
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? const Color(0xFFF5F2EE) : null,
                    ),
                  ),
                );
              }

              if (results.isEmpty) {
                return Center(
                  child: Text(
                    "ابدأ بكتابة اسم السورة أو الآية للبحث",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? const Color(0xFFB8AEA5) : Colors.grey,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: results.length,
                separatorBuilder: (context, index) => Divider(
                  height: 24,
                  color: isDark ? const Color(0xFF383430) : null,
                ),
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
                                ? (isDark
                                    ? const Color(0xFFC8A88A).withOpacity(0.2)
                                    : AppColors.thirdColor.withValues(alpha: 0.2))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: result.isSurah
                                ? Icon(
                                    Icons.menu_book,
                                    color: isDark
                                        ? const Color(0xFFC8A88A)
                                        : AppColors.thirdColor,
                                  )
                                : Icon(
                                    Icons.format_list_numbered,
                                    color: isDark
                                        ? const Color(0xFFB8AEA5)
                                        : Colors.grey,
                                    size: 20,
                                  ),
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
                                  color: isDark
                                      ? const Color(0xFFF5F2EE)
                                      : AppColors.thirdTextColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (!result.isSurah &&
                                  result.text != null &&
                                  result.text!.isNotEmpty)
                                Text(
                                  result.text!,
                                  style: TextStyle(
                                    fontFamily: 'QuranFont',
                                    fontSize: 18,
                                    height: 1.5,
                                    color: isDark
                                        ? const Color(0xFFF5F2EE)
                                        : Colors.black,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 4),
                              Text(
                                result.isSurah
                                    ? "تبدأ في الصفحة ${result.page ?? '-'}"
                                    : "آية ${result.verseNumber ?? '-'} • صفحة ${result.page ?? '-'}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? const Color(0xFFB8AEA5)
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: isDark
                              ? const Color(0xFFB8AEA5)
                              : Colors.grey,
                        ),
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
