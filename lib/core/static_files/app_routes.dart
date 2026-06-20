import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/auth/presentation/pages/login_screen.dart';
import 'package:islamic_app/features/auth/presentation/pages/signup_screen.dart';
import 'package:islamic_app/features/azkar/presentation/pages/daily_dua_view.dart';
import 'package:islamic_app/features/azkar/presentation/pages/daily_zikr.dart';
import 'package:islamic_app/features/home/presentation/pages/main_view.dart';
import 'package:islamic_app/features/home/presentation/pages/notification_details.dart';
import 'package:islamic_app/features/home/presentation/pages/splash_screen.dart';
import 'package:islamic_app/features/quran/presentation/pages/bookmark_screen.dart';
import 'package:islamic_app/features/quran/presentation/pages/daily_quran_paper.dart';
import 'package:islamic_app/features/quran/presentation/pages/surah_details_view.dart';
import 'package:islamic_app/features/quran/presentation/pages/quran_search_view.dart';
import 'package:islamic_app/features/azkar/presentation/pages/azkar_details_screen.dart';
import 'package:islamic_app/features/azkar/presentation/pages/electronic_tasbeeh_screen.dart';
import 'package:islamic_app/features/prayer/presentation/pages/adan_view.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/azkar_cubit.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/log-in';
  static const signup = '/sign-up';
  static const main = '/main';
  static const details = '/details';
  static const dailyDhikr = '/daily-dhikr';
  static const dailyDua = '/daily-dua';
  static const dailyQuranPaper = '/daily-quran-paper';
  static const bookmark = '/book-mark';
  static const surahDetails = '/surah-details';
  static const quranSearch = '/quran-search';
  static const azkarDetail = '/azkar-detail';
  static const electronicTasbeeh = '/electronic-tasbeeh';
  static const alarms = '/alarms';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainView());
      case details:
        return MaterialPageRoute(builder: (_) => const NotificationDetails());
      case dailyDhikr:
        return MaterialPageRoute(builder: (_) => const DailyZikr());
      case dailyDua:
        return MaterialPageRoute(builder: (_) => const DailyDuaView());
      case dailyQuranPaper:
        return MaterialPageRoute(builder: (_) => const DailyQuranPaper());
      case bookmark:
        return MaterialPageRoute(builder: (_) => const BookmarkScreen());
      case surahDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SurahDetailsView(
            surahName: args['surahName'] as String,
            initialPageNumber: args['initialPageNumber'] as int?,
          ),
        );
      case quranSearch:
        return MaterialPageRoute(builder: (_) => const QuranSearchView());
      case azkarDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AzkarCubit(),
            child: AzkarDetailScreen(
              categoryTitle: args['categoryTitle'] as String,
              categoryId: args['categoryId'] as int,
            ),
          ),
        );
      case electronicTasbeeh:
        return MaterialPageRoute(builder: (_) => const ElectronicTasbeehScreen());
      case alarms:
        return MaterialPageRoute(builder: (_) => const AdanView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
