import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_app/features/quran/data/models/surah_category.dart';

/// Service responsible for downloading, caching, checking, and deleting
/// Quran Surah audio files for offline playback.
class SurahAudioDownloadService {
  static final SurahAudioDownloadService _instance =
      SurahAudioDownloadService._internal();
  factory SurahAudioDownloadService() => _instance;
  SurahAudioDownloadService._internal();

  static const String _keyDownloadedSurahs = 'downloaded_surah_numbers';

  /// Gets the local directory dedicated for Quran audio downloads.
  Future<Directory> _getAudioDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${docsDir.path}/quran_audio');
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    return audioDir;
  }

  /// Generates a unique, clean filename from an audio URL.
  String _getFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    if (segments.isNotEmpty) {
      return segments.join('_').replaceAll(RegExp(r'[^\w\.-]'), '_');
    }
    return '${url.hashCode}.mp3';
  }

  /// Gets the full local file path for a given audio URL.
  Future<String> getLocalFilePath(String url) async {
    final dir = await _getAudioDirectory();
    final fileName = _getFileNameFromUrl(url);
    return '${dir.path}/$fileName';
  }

  /// Checks if the audio file for [url] is already downloaded and exists locally.
  Future<bool> isDownloaded(String url) async {
    try {
      final filePath = await getLocalFilePath(url);
      final file = File(filePath);
      return await file.exists() && (await file.length()) > 0;
    } catch (_) {
      return false;
    }
  }

  /// Robustly extracts Surah Number (1-114) from any audio filename or URL.
  int? _extractSurahNumberFromFilename(String fileName) {
    // 1. Look for 6-digit pattern e.g. 001001 (surah 001, verse 001)
    final match6 = RegExp(r'(\d{3})\d{3}').firstMatch(fileName);
    if (match6 != null) {
      final num = int.tryParse(match6.group(1)!);
      if (num != null && num >= 1 && num <= 114) return num;
    }

    // 2. Look for 3-digit pattern before .mp3 e.g. _001.mp3 or 001.mp3
    final match3 = RegExp(r'(\d{3})\.mp3').firstMatch(fileName);
    if (match3 != null) {
      final num = int.tryParse(match3.group(1)!);
      if (num != null && num >= 1 && num <= 114) return num;
    }

    // 3. Fallback: find any sequence of 3 digits that represents a valid Surah (1..114)
    final matches = RegExp(r'\d{3}').allMatches(fileName);
    for (final m in matches) {
      final num = int.tryParse(m.group(0)!);
      if (num != null && num >= 1 && num <= 114) return num;
    }

    return null;
  }

  /// Registers a downloaded surah number in SharedPreferences.
  Future<void> markSurahAsDownloaded(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyDownloadedSurahs) ?? [];
    if (!list.contains(surahNumber.toString())) {
      list.add(surahNumber.toString());
      await prefs.setStringList(_keyDownloadedSurahs, list);
    }
  }

  /// Removes a downloaded surah number from SharedPreferences.
  Future<void> unmarkSurahAsDownloaded(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyDownloadedSurahs) ?? [];
    if (list.contains(surahNumber.toString())) {
      list.remove(surahNumber.toString());
      await prefs.setStringList(_keyDownloadedSurahs, list);
    }
  }

  /// Returns the list of SurahCategory objects that are downloaded for offline listening.
  Future<List<SurahCategory>> getDownloadedSurahs() async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedIds = prefs.getStringList(_keyDownloadedSurahs) ?? [];
    final Set<int> numbers = downloadedIds
        .map((id) => int.tryParse(id) ?? 0)
        .where((n) => n > 0)
        .toSet();

    // Scan local audio directory to automatically detect previously downloaded files
    try {
      final dir = await _getAudioDirectory();
      if (await dir.exists()) {
        final files = dir.listSync();
        for (final entity in files) {
          if (entity is File && entity.lengthSync() > 0) {
            final fileName = entity.path.split(Platform.pathSeparator).last;
            final num = _extractSurahNumberFromFilename(fileName);
            if (num != null) {
              numbers.add(num);
              // Also sync to SharedPreferences for instant future lookups
              await markSurahAsDownloaded(num);
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error scanning downloaded files: $e');
      }
    }

    return SurahCategory.surahCategories
        .where((s) => numbers.contains(s.number))
        .toList();
  }

  /// Downloads the Surah audio file from [url].
  Future<void> downloadAudio({
    required String url,
    required void Function(double progress) onProgress,
    required void Function(String localPath) onCompleted,
    required void Function(String error) onError,
  }) async {
    try {
      final localPath = await getLocalFilePath(url);
      final file = File(localPath);

      final tempFile = File('$localPath.tmp');
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      final request = http.Request('GET', Uri.parse(url));
      final response = await http.Client().send(request);

      if (response.statusCode != 200) {
        onError('فشل التنزيل (رمز الاستجابة: ${response.statusCode})');
        return;
      }

      final totalBytes = response.contentLength ?? 0;
      int bytesDownloaded = 0;

      final sink = tempFile.openWrite();

      await response.stream.listen(
        (chunk) {
          bytesDownloaded += chunk.length;
          sink.add(chunk);

          if (totalBytes > 0) {
            final progress = (bytesDownloaded / totalBytes).clamp(0.0, 1.0);
            onProgress(progress);
          }
        },
        onDone: () async {
          await sink.flush();
          await sink.close();

          if (await file.exists()) {
            await file.delete();
          }
          await tempFile.rename(localPath);

          // Mark Surah as downloaded
          final fileName = _getFileNameFromUrl(url);
          final surahNum =
              _extractSurahNumberFromFilename(fileName) ??
              _extractSurahNumberFromFilename(url);
          if (surahNum != null) {
            await markSurahAsDownloaded(surahNum);
          }

          onProgress(1.0);
          onCompleted(localPath);
        },
        onError: (error) async {
          await sink.close();
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
          onError('حدث خطأ أثناء التنزيل: $error');
        },
        cancelOnError: true,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Download error: $e');
      }
      onError('تعذر الاتصال بالخادم لتنزيل السورة.');
    }
  }

  /// Deletes a downloaded Surah audio file for [url].
  Future<bool> deleteAudio(String url) async {
    try {
      final filePath = await getLocalFilePath(url);
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        final fileName = _getFileNameFromUrl(url);
        final surahNum =
            _extractSurahNumberFromFilename(fileName) ??
            _extractSurahNumberFromFilename(url);
        if (surahNum != null) {
          await unmarkSurahAsDownloaded(surahNum);
        }
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Delete error: $e');
      }
    }
    return false;
  }
}
