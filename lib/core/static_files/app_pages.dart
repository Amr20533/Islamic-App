import 'package:flutter/material.dart';
import 'package:islamic_app/features/auth/presentation/pages/login_screen.dart';
import 'package:islamic_app/features/auth/presentation/pages/signup_screen.dart';
import 'package:islamic_app/features/azkar/presentation/pages/daily_dua_view.dart';
import 'package:islamic_app/features/azkar/presentation/pages/daily_zikr.dart';
import 'package:islamic_app/features/home/presentation/pages/main_view.dart';
import 'package:islamic_app/features/home/presentation/pages/notification_details.dart';
import 'package:islamic_app/features/home/presentation/pages/splash_screen.dart';
import 'package:islamic_app/features/quran/presentation/pages/bookmark_screen.dart';
import 'package:islamic_app/features/quran/presentation/pages/daily_quran_paper.dart';
import 'app_routes.dart';

class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case AppRoutes.main:
        return MaterialPageRoute(builder: (_) => MainView());
      case AppRoutes.details:
        return MaterialPageRoute(builder: (_) => NotificationDetails());
      case AppRoutes.dailyDhikr:
        return MaterialPageRoute(builder: (_) => DailyZikr());
      case AppRoutes.dailyDua:
        return MaterialPageRoute(builder: (_) => DailyDuaView());
      case AppRoutes.dailyQuranPaper:
        return MaterialPageRoute(builder: (_) => DailyQuranPaper());
      case AppRoutes.bookmark:
        return MaterialPageRoute(builder: (_) => BookmarkScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
