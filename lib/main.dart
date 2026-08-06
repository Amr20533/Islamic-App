import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:islamic_app/di/locator.dart' as service_locator;
import 'package:islamic_app/features/auth/cubit/user_profile_cubit.dart';
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
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Run independent, fast inits in parallel instead of sequentially
  final sharedPreferences = await SharedPreferences.getInstance();
  await Future.wait([
    initializeDateFormatting('ar', null),
  ]);

  service_locator.setupLocator(sharedPreferences);

  final cachedLat = sharedPreferences.getDouble('last_lat') ?? 30.0444;
  final cachedLng = sharedPreferences.getDouble('last_lng') ?? 31.2357;

  service_locator.locator.registerLazySingleton<PrayerCubit>(
        () => PrayerCubit(latitude: cachedLat, longitude: cachedLng),
  );

  runApp(const MyApp());

  // Everything below runs AFTER first frame — doesn't block startup.
  _updateLocationInBackground(sharedPreferences);
  _initNotificationsInBackground();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// Adds [WidgetsBindingObserver] so we can call [NotificationService.onAppResumed]
/// when the user returns from the "Alarms & Reminders" Settings screen after
/// [requestExactAlarmsPermission] sent them there.
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      NotificationService().onAppResumed();
    }
  }

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
        BlocProvider(
          create: (_) => service_locator.locator<UserProfileCubit>()..loadUser(),
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

Future<void> _updateLocationInBackground(SharedPreferences prefs) async {
  try {
    final position = await LocationHelper.getCurrentLocation();
    if (position == null) return;

    // persist for instant startup next time
    await prefs.setDouble('last_lat', position.latitude);
    await prefs.setDouble('last_lng', position.longitude);

    if (service_locator.locator.isRegistered<PrayerCubit>()) {
      service_locator.locator<PrayerCubit>()
          .updateLocation(position.latitude, position.longitude);
    }
    debugPrint('📍 Location updated: ${position.latitude}, ${position.longitude}');
  } catch (e) {
    debugPrint('⚠️ Location not available: $e');
  }
}

Future<void> _initNotificationsInBackground() async {
  debugPrint('🔔 Initializing notifications...');
  await NotificationService().init();
  await NotificationService().scheduleDailyReminderAt(hour: 8, minute: 0);
  debugPrint('✅ Notifications ready');
}