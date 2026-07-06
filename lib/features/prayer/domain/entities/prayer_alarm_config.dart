class PrayerAlarmConfig {
  final String key;
  final String name;
  final String iconPath;
  final int notificationId;

  const PrayerAlarmConfig({
    required this.key,
    required this.name,
    required this.iconPath,
    required this.notificationId,
  });
}

const List<PrayerAlarmConfig> prayerAlarmConfigs = [
  PrayerAlarmConfig(
    key: 'alarm_fajr',
    name: 'الفجر',
    iconPath: 'assets/images/fajr.png',
    notificationId: 201,
  ),
  PrayerAlarmConfig(
    key: 'alarm_shuruq',
    name: 'الشروق',
    iconPath: 'assets/images/sunrise.png',
    notificationId: 202,
  ),
  PrayerAlarmConfig(
    key: 'alarm_dhuhr',
    name: 'الظهر',
    iconPath: 'assets/images/dhuhr.png',
    notificationId: 203,
  ),
  PrayerAlarmConfig(
    key: 'alarm_asr',
    name: 'العصر',
    iconPath: 'assets/images/asr.png',
    notificationId: 204,
  ),
  PrayerAlarmConfig(
    key: 'alarm_maghrib',
    name: 'المغرب',
    iconPath: 'assets/images/maghrib.png',
    notificationId: 205,
  ),
  PrayerAlarmConfig(
    key: 'alarm_isha',
    name: 'العشاء',
    iconPath: 'assets/images/isha.png',
    notificationId: 206,
  ),
];
