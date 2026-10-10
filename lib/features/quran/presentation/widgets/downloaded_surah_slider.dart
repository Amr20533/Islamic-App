import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/quran/data/models/surah_category.dart';
import 'package:islamic_app/features/quran/data/services/surah_audio_download_service.dart';
import 'package:islamic_app/features/quran/presentation/widgets/surah_tile.dart';

class DownloadedSurahSlider extends StatefulWidget {
  const DownloadedSurahSlider({super.key});

  @override
  State<DownloadedSurahSlider> createState() => _DownloadedSurahSliderState();
}

class _DownloadedSurahSliderState extends State<DownloadedSurahSlider> {
  late Future<List<SurahCategory>> _downloadedSurahsFuture;

  @override
  void initState() {
    super.initState();
    _loadDownloadedSurahs();
  }

  void _loadDownloadedSurahs() {
    setState(() {
      _downloadedSurahsFuture = SurahAudioDownloadService()
          .getDownloadedSurahs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: FutureBuilder<List<SurahCategory>>(
          future: _downloadedSurahsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final downloadedSurahs = snapshot.data ?? [];

            if (downloadedSurahs.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFFC8A88A).withOpacity(0.12)
                              : AppColors.primaryColor.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.cloud_download_outlined,
                          size: 54,
                          color: isDark
                              ? const Color(0xFFC8A88A)
                              : AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد سور منزلة بعد',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? const Color(0xFFF5F2EE)
                              : AppColors.counterColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'يمكنك تنزيل أي سورة للاستماع إليها بدون إنترنت عن طريق فتح السورة والضغط على زر التنزيل في مشغل الصوت أسفل الشاشة.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 13,
                          height: 1.5,
                          color: isDark
                              ? const Color(0xFFB8AEA5)
                              : AppColors.thirdTextColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? const Color(0xFFC8A88A)
                              : AppColors.primaryColor,
                          foregroundColor: isDark
                              ? const Color(0xFF141312)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        onPressed: _loadDownloadedSurahs,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text(
                          'تحديث القائمة',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadDownloadedSurahs();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        const SizedBox(width: 6),
                        Text(
                          'السور المنزلة للاستماع بدون إنترنت (${downloadedSurahs.length})',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? const Color(0xFFC8A88A)
                                : AppColors.counterColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: downloadedSurahs.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final surah = downloadedSurahs[index];
                        final isLast = index == downloadedSurahs.length - 1;
                        return SurahTile(surahModel: surah, isLast: isLast);
                      },
                      separatorBuilder: (context, _) =>
                          const SizedBox(height: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
