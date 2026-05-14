import 'package:get_it/get_it.dart';
import 'package:islamic_app/core/services/notification_service.dart';
import 'package:islamic_app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/azkar_cubit.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/daily_dhikr_cubit.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/adhan_bloc.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/adhan_event.dart';
import 'package:islamic_app/features/quran/presentation/bloc/quran_cubit.dart';
import 'package:islamic_app/features/quran/presentation/bloc/surah_selector_cubit.dart';
import 'package:islamic_app/features/ramadan/presentation/bloc/ramadan_cubit.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AudioCubit>(() => AudioCubit());
  locator.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );
  locator.registerLazySingleton<QuranCubit>(() => QuranCubit());
  locator.registerLazySingleton<RamadanCubit>(() => RamadanCubit());
  locator.registerLazySingleton<AzkarCubit>(() => AzkarCubit());
  locator.registerLazySingleton<DailyDhikrCubit>(() => DailyDhikrCubit());
  locator.registerLazySingleton<SurahSelectorCubit>(() => SurahSelectorCubit());
  locator.registerLazySingleton<AdhanBloc>(
    () => AdhanBloc()..add(AdhanInitializeEvent()),
  );
}
