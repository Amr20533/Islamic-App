import 'package:islamic_app/core/models/audio.dart';
import 'package:islamic_app/core/models/name.dart';
import 'package:islamic_app/core/models/revelation_place.dart';
import 'package:islamic_app/core/models/verse.dart';

class SurahModel {
  int? number;
  Name? name;
  RevelationPlace? revelationPlace;
  int? versesCount;
  int? wordsCount;
  int? lettersCount;
  List<Verse>? verses;
  List<Audio>? audio;

  SurahModel({
    this.number,
    this.name,
    this.revelationPlace,
    this.versesCount,
    this.wordsCount,
    this.lettersCount,
    this.verses,
    this.audio,
  });

  SurahModel.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    revelationPlace = json['revelation_place'] != null
        ? RevelationPlace.fromJson(json['revelation_place']) : null;
    versesCount = json['verses_count'];
    wordsCount = json['words_count'];
    lettersCount = json['letters_count'];
    if (json['verses'] != null) {
      verses = <Verse>[];
      json['verses'].forEach((v) => verses!.add(Verse.fromJson(v)));
    }
    if (json['audio'] != null) {
      audio = <Audio>[];
      json['audio'].forEach((v) => audio!.add(Audio.fromJson(v)));
    }
  }
}



