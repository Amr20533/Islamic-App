class Name {
  String? ar, en, transliteration;
  Name({this.ar, this.en, this.transliteration});
  Name.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
    transliteration = json['transliteration'];
  }
}
