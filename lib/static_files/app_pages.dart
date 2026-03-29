import 'package:get/get.dart';
import 'package:islamic_app/views/home/daily_dua_view.dart';
import 'package:islamic_app/views/home/daily_quran_paper.dart';
import 'package:islamic_app/views/home/daily_zikr.dart';
import 'package:islamic_app/views/main_view.dart';
import 'package:islamic_app/views/notification_details.dart';
import 'package:islamic_app/views/start/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => MainView(),
    ),
    GetPage(
      name: AppRoutes.details,
      page: () => NotificationDetails(),
    ),

    GetPage(
      name: AppRoutes.dailyDhikr,
      page: () => DailyZikr(),
    ),

    GetPage(
      name: AppRoutes.dailyDua,
      page: () => DailyDuaView(),
    ),

    GetPage(
      name: AppRoutes.dailyQuranPaper,
      page: () => DailyQuranPaper(),
    ),

  ];
}
