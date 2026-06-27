class DailyNotification {
  final int id;
  final String title;
  final String body;
  final int hour;
  final int minute;
  final bool isEnabled;

  DailyNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.hour,
    required this.minute,
    this.isEnabled = true,
  });

  // تحويل للـ JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'hour': hour,
      'minute': minute,
      'isEnabled': isEnabled,
    };
  }

  // من JSON
  factory DailyNotification.fromJson(Map<String, dynamic> json) {
    return DailyNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      hour: json['hour'],
      minute: json['minute'],
      isEnabled: json['isEnabled'] ?? true,
    );
  }
}
