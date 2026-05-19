class AudioReciter {
  final int id;
  final String reciterNameAr;
  final String reciterNameEn;
  final String rewayaAr;
  final String rewayaEn;
  final String server;
  final String link;

  AudioReciter({
    required this.id,
    required this.reciterNameAr,
    required this.reciterNameEn,
    required this.rewayaAr,
    required this.rewayaEn,
    required this.server,
    required this.link,
  });

  factory AudioReciter.fromJson(Map<String, dynamic> json) {
    return AudioReciter(
      id: json['id'] ?? 0,
      reciterNameAr: json['reciter']?['ar'] ?? '',
      reciterNameEn: json['reciter']?['en'] ?? '',
      rewayaAr: json['rewaya']?['ar'] ?? '',
      rewayaEn: json['rewaya']?['en'] ?? '',
      server: json['server'] ?? '',
      link: json['link'] ?? '',
    );
  }
}
