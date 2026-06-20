import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_app/core/services/notification_service.dart';
import 'package:islamic_app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/azkar_cubit.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/daily_dhikr_cubit.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/adhan_bloc.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/adhan_event.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_search_cubit.dart';
import 'package:islamic_app/features/quran/presentation/bloc/surah_selector_cubit.dart';
import 'package:islamic_app/features/ramadan/presentation/bloc/ramadan_cubit.dart';

// Calendar clean architecture registrations
import 'package:islamic_app/features/calendar/data/datasources/calendar_local_datasource.dart';
import 'package:islamic_app/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:islamic_app/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:islamic_app/features/calendar/presentation/bloc/calendar_cubit.dart';

// Prayer alarm clean architecture registrations
import 'package:islamic_app/features/prayer/data/datasources/prayer_alarm_local_datasource.dart';
import 'package:islamic_app/features/prayer/data/repositories/prayer_alarm_repository_impl.dart';
import 'package:islamic_app/features/prayer/domain/repositories/prayer_alarm_repository.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_alarm_cubit.dart';

// Profile Feature
import 'package:islamic_app/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:islamic_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:islamic_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_cubit.dart';

final GetIt locator = GetIt.instance;

void setupLocator(SharedPreferences sharedPreferences) {
  // SharedPreferences
  locator.registerSingleton<SharedPreferences>(sharedPreferences);

  // Cubits & Blocs
  locator.registerLazySingleton<AudioCubit>(() => AudioCubit());
  locator.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );
  locator.registerLazySingleton<QuranCubit>(() => QuranCubit());
  locator.registerLazySingleton<QuranSearchCubit>(() => QuranSearchCubit());
  locator.registerLazySingleton<RamadanCubit>(() => RamadanCubit());
  locator.registerLazySingleton<AzkarCubit>(() => AzkarCubit());
  locator.registerLazySingleton<DailyDhikrCubit>(() => DailyDhikrCubit());
  locator.registerLazySingleton<SurahSelectorCubit>(() => SurahSelectorCubit());
  locator.registerLazySingleton<AdhanBloc>(
    () => AdhanBloc()..add(AdhanInitializeEvent()),
  );

  // Calendar Feature
  locator.registerLazySingleton<CalendarLocalDataSource>(
    () => CalendarLocalDataSourceImpl(sharedPreferences: locator<SharedPreferences>()),
  );
  locator.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(localDataSource: locator<CalendarLocalDataSource>()),
  );
  locator.registerFactory<CalendarCubit>(
    () => CalendarCubit(repository: locator<CalendarRepository>()),
  );

  // Prayer Alarm Feature
  locator.registerLazySingleton<PrayerAlarmLocalDataSource>(
    () => PrayerAlarmLocalDataSourceImpl(sharedPreferences: locator<SharedPreferences>()),
  );
  locator.registerLazySingleton<PrayerAlarmRepository>(
    () => PrayerAlarmRepositoryImpl(localDataSource: locator<PrayerAlarmLocalDataSource>()),
  );
  locator.registerFactory<PrayerAlarmCubit>(
    () => PrayerAlarmCubit(
      repository: locator<PrayerAlarmRepository>(),
      notificationService: locator<NotificationService>(),
    ),
  );

  // Profile Feature
  locator.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(sharedPreferences: locator<SharedPreferences>()),
  );
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(localDataSource: locator<ProfileLocalDataSource>()),
  );
  locator.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(
      repository: locator<ProfileRepository>(),
      notificationService: locator<NotificationService>(),
    ),
  );
}
