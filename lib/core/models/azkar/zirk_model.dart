import 'package:islamic_app/core/models/azkar/zikr_item.dart';

class AzkarModel {
  final int id;
  final String title;
  final String audioUrl;
  final List<ZikrItem> zikrList;

  AzkarModel({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.zikrList,
  });

  factory AzkarModel.fromJson(Map<String, dynamic> json) {
    // Access the first object in the ZIKR list
    var zikrData = json['ZIKR'][0] as Map<String, dynamic>;

    // Since the key matches the "TITLE", we grab the first value in that map
    var innerList = zikrData.values.first as List;

    return AzkarModel(
      id: json['ID'] ?? 0,
      title: json['TITLE'] ?? '',
      audioUrl: json['AUDIO_URL'] ?? '',
      zikrList: innerList.map((i) => ZikrItem.fromJson(i)).toList(),
    );
  }
}