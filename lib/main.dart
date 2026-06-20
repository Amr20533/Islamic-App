import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:islamic_app/di/locator.dart' as service_locator;
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_cubit.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/adhan_bloc.dart';
import 'package:islamic_app/features/quran/presentation/bloc/surah_selector_cubit.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/azkar_cubit.dart';
import 'package:islamic_app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:islamic_app/features/ramadan/presentation/bloc/ramadan_cubit.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/daily_dhikr_cubit.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_search_cubit.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:islamic_app/core/services/helpers/location_helper.dart';
import 'package:islamic_app/core/services/notification_service.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'core/static_files/app_colors.dart';

import 'package:shared_preferences/shared_preferences.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null);
  final sharedPreferences = await SharedPreferences.getInstance();
  setupLocator(sharedPreferences);
  await _getLocation();
  runApp(const MyApp());
  await NotificationService().init();
  await NotificationService().scheduleDailyReminders();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<PrayerCubit>()),
        BlocProvider(create: (_) => locator<AdhanBloc>()),
        BlocProvider(create: (_) => locator<SurahSelectorCubit>()),
        BlocProvider(create: (_) => locator<AzkarCubit>()..loadCategories()),
        BlocProvider(create: (_) => locator<AudioCubit>()),
        BlocProvider(
          create: (_) => locator<RamadanCubit>()..fetchPrayerTimes(),
        ),
        BlocProvider(create: (_) => locator<DailyDhikrCubit>()),
        BlocProvider(create: (_) => locator<QuranCubit>()),
        BlocProvider(create: (_) => locator<QuranSearchCubit>()),
        BlocProvider(create: (_) => locator<ProfileCubit>()..loadProfile()),
      ],
      child: MaterialApp(
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
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),
        ),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
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

  if (!locator.isRegistered<PrayerCubit>()) {
    locator.registerLazySingleton<PrayerCubit>(
      () => PrayerCubit(
        latitude: position?.latitude ?? 30.0444,
        longitude: position?.longitude ?? 31.2357,
      ),
    );
  }
}
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة التاريخ بالعربية
  await initializeDateFormatting('ar', null);

  // ✅ الحصول على SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  service_locator.setupLocator(sharedPreferences);

  // ✅ الحصول على الموقع الجغرافي
  await _getLocation();

  // ✅ تهيئة الإشعارات قبل runApp
  debugPrint('🔔 Initializing notifications...');
  await NotificationService().init();
  debugPrint('✅ Notifications initialized');

  debugPrint('📅 Scheduling daily reminders...');
  await NotificationService().scheduleDailyReminders();
  debugPrint('✅ Daily reminders scheduled');

  // ✅ شغّل التطبيق آخراً
  runApp(const MyApp());
}

/// الحصول على الموقع الجغرافي للمستخدم
Future<void> _getLocation() async {
  try {
    final position = await LocationHelper.getCurrentLocation();
    debugPrint('📍 Location: ${position?.latitude}, ${position?.longitude}');

    if (!service_locator.locator.isRegistered<PrayerCubit>()) {
      service_locator.locator.registerLazySingleton<PrayerCubit>(
        () => PrayerCubit(
          latitude: position?.latitude ?? 30.0444,
          longitude: position?.longitude ?? 31.2357,
        ),
      );
    }
  } catch (e) {
    debugPrint('⚠️ Location not available: $e');
    debugPrint('📍 Using default location (Cairo)');

    if (!service_locator.locator.isRegistered<PrayerCubit>()) {
      service_locator.locator.registerLazySingleton<PrayerCubit>(
        () => PrayerCubit(latitude: 30.0444, longitude: 31.2357),
      );
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => service_locator.locator<PrayerCubit>()),
        BlocProvider(create: (_) => service_locator.locator<AdhanBloc>()),
        BlocProvider(
          create: (_) => service_locator.locator<SurahSelectorCubit>(),
        ),
        BlocProvider(
          create: (_) =>
              service_locator.locator<AzkarCubit>()..loadCategories(),
        ),
        BlocProvider(create: (_) => service_locator.locator<AudioCubit>()),
        BlocProvider(
          create: (_) =>
              service_locator.locator<RamadanCubit>()..fetchPrayerTimes(),
        ),
        BlocProvider(create: (_) => service_locator.locator<DailyDhikrCubit>()),
        BlocProvider(create: (_) => service_locator.locator<QuranCubit>()),
        BlocProvider(
          create: (_) => service_locator.locator<QuranSearchCubit>(),
        ),
        BlocProvider(
          create: (_) => service_locator.locator<ProfileCubit>()..loadProfile(),
        ),
      ],
      child: MaterialApp(
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
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),
        ),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
