import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to handle fetching Tafsir (exegesis) data.
class QuranTafsirService {
  /// Fetches Tafsir Al-Saadi (Resource ID 91 on Quran.com) for a specific verse.
  static Future<String> fetchTafsir(int surahNumber, int verseNumber) async {
    try {
      final url = Uri.parse(
        'https://api.quran.com/api/v4/tafsirs/91/by_ayah/$surahNumber:$verseNumber',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Decode bytes with UTF-8 to handle Arabic text correctly
        final responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);

        // Check for single 'tafsir' object (as returned by single ayah endpoint)
        if (data['tafsir'] != null && data['tafsir']['text'] != null) {
          final String text = data['tafsir']['text'] ?? '';
          return _cleanTafsirText(text);
        }

        // Fallback for 'tafsirs' list if returned
        final List? tafsirs = data['tafsirs'];
        if (tafsirs != null && tafsirs.isNotEmpty) {
          final String text = tafsirs[0]['text'] ?? '';
          return _cleanTafsirText(text);
        }
      }
      throw Exception('Failed to load tafsir (status: ${response.statusCode})');
    } catch (e) {
      throw Exception('عذراً، تعذر تحميل التفسير. التفاصيل: $e');
    }
  }

  /// Helper method to strip HTML tags and decode common entities.
  static String _cleanTafsirText(String htmlText) {
    if (htmlText.isEmpty) return '';
    // Strip HTML tags using regex
    String clean = htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
    // Decode HTML entities
    clean = clean
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'");
    return clean.trim();
  }
}
