class RevelationPlace {
  String? ar, en;
  RevelationPlace({this.ar, this.en});
  RevelationPlace.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }
}

