
import 'package:islamic_app/core/models/name.dart';

class Audio {
  int? id;
  Name? reciter;
  Name? rewaya;
  String? server, link;

  Audio({this.id, this.reciter, this.rewaya, this.server, this.link});
  Audio.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reciter = json['reciter'] != null ? Name.fromJson(json['reciter']) : null;
    rewaya = json['rewaya'] != null ? Name.fromJson(json['rewaya']) : null;
    server = json['server'];
    link = json['link'];
  }
}