
class ZikrItem {
  final int id;
  final String arabicText;
  final String translatedText;
  final int repeat;
  final String audio;

  ZikrItem({
    required this.id,
    required this.arabicText,
    required this.translatedText,
    required this.repeat,
    required this.audio,
  });

  factory ZikrItem.fromJson(Map<String, dynamic> json) {
    return ZikrItem(
      id: json['ID'] ?? 0,
      arabicText: json['ARABIC_TEXT'] ?? '',
      translatedText: (json['TRANSLATED_TEXT']?.isEmpty ?? true)
          ? "Translation not available"
          : json['TRANSLATED_TEXT'],
      repeat: json['REPEAT'] ?? 1,
      audio: json['AUDIO'] ?? '',
    );
  }
}
