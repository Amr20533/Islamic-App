import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/auth/presentation/pages/login_screen.dart';
import 'package:islamic_app/features/auth/presentation/pages/signup_screen.dart';
import 'package:islamic_app/features/azkar/presentation/pages/daily_dua_view.dart';
import 'package:islamic_app/features/azkar/presentation/pages/daily_zikr.dart';
import 'package:islamic_app/features/home/presentation/pages/main_view.dart';
import 'package:islamic_app/features/home/presentation/pages/notification_details.dart';
import 'package:islamic_app/features/home/presentation/pages/splash_screen.dart';
import 'package:islamic_app/features/onbording/data/services/image_picker_service.dart';
import 'package:islamic_app/features/onbording/presentation/cubit/onbording_image_cubit.dart';
import 'package:islamic_app/features/onbording/presentation/cubit/selected_gender_cubit.dart';
import 'package:islamic_app/features/onbording/presentation/screens/birth_date_view.dart';
import 'package:islamic_app/features/onbording/presentation/screens/gender_selection_view.dart';
import 'package:islamic_app/features/onbording/presentation/screens/choose_a_picture.dart';
import 'package:islamic_app/features/onbording/presentation/screens/good_start.dart';
import 'package:islamic_app/features/quran/presentation/pages/bookmark_screen.dart';
import 'package:islamic_app/features/quran/presentation/pages/daily_quran_paper.dart';
import 'package:islamic_app/features/quran/presentation/pages/surah_details_view.dart';
import 'package:islamic_app/features/quran/presentation/pages/quran_search_view.dart';
import 'package:islamic_app/features/azkar/presentation/pages/azkar_details_screen.dart';
import 'package:islamic_app/features/azkar/presentation/pages/electronic_tasbeeh_screen.dart';
import 'package:islamic_app/features/prayer/presentation/pages/adan_view.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/azkar_cubit.dart';
import 'package:islamic_app/features/onbording/presentation/screens/onpording_1.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/log-in';
  static const signup = '/sign-up';
  static const main = '/main';
  static const onboarding1 = '/onboarding-1';
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
  static const onpording1 = '/onpording-1';
  static const chooseAPicture = '/choose-a-picture';
  static const genderSelectionView = '/GenderSelectionView';
  static const birthDateView = '/birth-date-view';
  static const goodStart = '/good-start';

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
        return MaterialPageRoute(
          builder: (_) => const ElectronicTasbeehScreen(),
        );
      case alarms:
        return MaterialPageRoute(builder: (_) => const AdanView());
      case onpording1:
        return MaterialPageRoute(builder: (_) => const Onpording1());

      case chooseAPicture:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OnboardingImageCubit(ImagePickerService()),
            child: const ChooseAPicture(),
          ),
        );
      case genderSelectionView:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => GenderCubit(),
            child: const GenderSelectionView(),
          ),
        );

      case goodStart:
        return MaterialPageRoute(builder: (_) => const GoodStart());

      case birthDateView:
        return MaterialPageRoute(builder: (_) => const BirthDateView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
