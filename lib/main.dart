import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:islamic_app/core/controllers/prayer_controller.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/services/helpers/location_helper.dart';
import 'package:islamic_app/services/notification_service.dart';
import 'package:islamic_app/static_files/app_pages.dart';
import 'package:islamic_app/static_files/app_routes.dart';
import 'package:islamic_app/static_files/app_text_styles.dart';

import 'static_files/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null);
  // Other controllers
  setupLocator();

  // Register PrayerController with actual or fallback coordinates
  await _getLocation();

  runApp(const MyApp());
  await NotificationService().init();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Islamic App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.whiteColor,

        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primaryColor,
          onPrimary: AppColors.whiteColor,
          secondary: AppColors.secondaryColor,
          onSecondary: AppColors.whiteColor,
          tertiary: AppColors.thirdColor,
          onTertiary: AppColors.primaryTextColor,
          surface: AppColors.whiteColor,
          onSurface: AppColors.primaryTextColor,
          error: Colors.redAccent,
          onError: AppColors.whiteColor,
          outline: AppColors.greyColor,
        ),

        fontFamily: 'Tajawal',
        textTheme: AppTextStyles.textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0
        ),
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}


Future<void> _getLocation() async {
  Position? position;

  try {
    position = await LocationHelper.getCurrentLocation();
  } catch (e) {
    print("Location not available: $e");
  }

  if (!locator.isRegistered<PrayerController>()) {
    // Use GPS if available, else fallback to default Cairo coordinates
    locator.registerLazySingleton<PrayerController>(
          () => PrayerController(
        latitude: position?.latitude ?? 30.0444,
        longitude: position?.longitude ?? 31.2357,
      ),
    );
  }
}
