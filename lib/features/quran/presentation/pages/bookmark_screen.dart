import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/features/quran/data/services/quran_bookmark_service.dart';

/// Screen displaying all bookmarked Quranic verses.
class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<QuranBookmark> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = locator<SharedPreferences>();
    final list = await QuranBookmarkService.getBookmarks(prefs);
    if (mounted) {
      setState(() {
        _bookmarks = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeBookmark(QuranBookmark bookmark) async {
    final prefs = locator<SharedPreferences>();
    await QuranBookmarkService.removeBookmark(
      bookmark.surahNumber,
      bookmark.verseNumber,
      prefs,
    );
    await _loadBookmarks();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "تمت إزالة الآية من المفضلة بنجاح 🌱",
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: isDark ? const Color(0xFF1B1A18) : null,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark ? const Color(0xFFC8A88A) : const Color(0xFF8B4513),
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "الآيات المفضلة",
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: isDark ? const Color(0xFFF5F2EE) : const Color(0xFF3E2723),
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? const Color(0xFFC8A88A) : const Color(0xFF8B4513),
                  ),
                ),
              )
            : _bookmarks.isEmpty
                ? const EmptyBookmark()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _bookmarks.length,
                    itemBuilder: (context, index) {
                      final bookmark = _bookmarks[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF242220) : const Color(0xFFF5F1E8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF383430)
                                : const Color(0xFFD4A574).withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.surahDetails,
                              arguments: {
                                'surahName': bookmark.surahName,
                                'initialPageNumber': bookmark.pageNumber,
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Title and delete button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'سورة ${bookmark.surahName} - آية ${bookmark.verseNumber}',
                                      style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? const Color(0xFFC8A88A)
                                            : const Color(0xFF8B4513),
                                      ),
                                    ),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.bookmark_remove_rounded,
                                        color: isDark
                                            ? const Color(0xFFE57373)
                                            : const Color(0xFFC62828),
                                        size: 22,
                                      ),
                                      onPressed: () => _removeBookmark(bookmark),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Divider(
                                  color: isDark
                                      ? const Color(0xFF383430)
                                      : const Color(0xFFE5D5C5),
                                  height: 1,
                                ),
                                const SizedBox(height: 12),
                                // Verse Arabic text
                                Text(
                                  bookmark.verseText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'QuranFont',
                                    fontSize: 18,
                                    color: isDark
                                        ? const Color(0xFFF5F2EE)
                                        : const Color(0xFF2C1C12),
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class EmptyBookmark extends StatelessWidget {
  const EmptyBookmark({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "لا توجد علامات محفوظة بعد",
            style: AppTextStyles.textTheme.labelMedium!.copyWith(
              fontSize: 16,
              color: isDark ? const Color(0xFFB8AEA5) : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "ابدأ بحفظ الآيات التي تريد الرجوع إليها 🌱",
            style: AppTextStyles.textTheme.labelMedium!.copyWith(
              fontSize: 16,
              color: isDark ? const Color(0xFFB8AEA5) : null,
            ),
          ),
        ],
      ),
    );
  }
}
