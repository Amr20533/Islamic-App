import 'package:get_it/get_it.dart';
import 'package:islamic_app/core/controllers/audio_controller.dart';
import 'package:islamic_app/core/controllers/azkar_controller.dart';
import 'package:islamic_app/core/controllers/daily_dhikr_controller.dart';
import 'package:islamic_app/core/controllers/quran_controller.dart';
import 'package:islamic_app/core/controllers/ramadan_controller.dart';
import 'package:islamic_app/services/notification_service.dart';
import '../core/controllers/adhan_controller.dart';
import '../core/controllers/main_controller.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<MainController>(
        () => MainController(),
  );
  locator.registerLazySingleton<AudioController>(
        () => AudioController(),
  );
  // Add this line
  locator.registerLazySingleton<NotificationService>(
        () => NotificationService(),
  );
  locator.registerLazySingleton<QuranController>(
        () => QuranController(),
  );
  locator.registerLazySingleton<RamadanController>(
        () => RamadanController()..fetchPrayerTimes(),
  );

  locator.registerLazySingleton<AzkarController>(
        () => AzkarController(),
  );

  locator.registerLazySingleton<AdhanController>(
        () => AdhanController(),
  );

  locator.registerLazySingleton<DailyDhikrController>(
        () => DailyDhikrController(),
  );

  // locator.registerLazySingleton<PrayerController>(
  //       () => PrayerController(latitude: 30.0444, longitude: 31.2357),
  // );

}