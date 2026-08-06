import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_shadows.dart';
import 'package:islamic_app/features/home/presentation/widgets/bottom_nav_item.dart';
import 'package:islamic_app/features/home/presentation/pages/home_view.dart';
import 'package:islamic_app/features/profile/presentation/pages/my_profile_view.dart';
import 'package:islamic_app/features/quran/presentation/pages/quran_view.dart';
import 'package:islamic_app/features/azkar/presentation/pages/zikr_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/adhan_bloc.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/adhan_state.dart';
import 'package:islamic_app/features/prayer/presentation/widgets/adhan_overlay.dart';

import 'package:islamic_app/features/calendar/presentation/pages/calendar_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const HomeView(),
      const QuranView(),
      ZikrView(),
      const CalendarView(),
      const MyProfileView(),
    ];
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdhanBloc, AdhanState>(
      listener: (context, state) {
        if (state is AdhanPlaying) {
          showDialog(
            context: context,
            barrierDismissible: false,
            useSafeArea: false,
            builder: (_) => AdhanOverlay(prayerName: state.prayerName),
          );
        }
      },
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            margin: EdgeInsets.fromLTRB(
              24,
              0,
              24,
              MediaQuery.of(context).viewPadding.bottom + 24,
            ),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(width: 1, color: AppColors.lightGreyColor),
              boxShadow: AppShadows.customShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomNavItem(
                  index: 0,
                  currentIndex: currentIndex,
                  iconPath: 'assets/icons/tabler_home.png',
                  label: 'الرئيسية',
                  onTap: () => changePage(0),
                ),
                BottomNavItem(
                  index: 1,
                  currentIndex: currentIndex,
                  iconPath: 'assets/icons/book.png',
                  label: 'القرآن',
                  onTap: () => changePage(1),
                ),
                BottomNavItem(
                  index: 2,
                  currentIndex: currentIndex,
                  iconPath: 'assets/icons/Tasbeeh.png',
                  label: 'الأذكار',
                  onTap: () => changePage(2),
                ),
                BottomNavItem(
                  index: 3,
                  currentIndex: currentIndex,
                  iconPath: 'assets/icons/calendar.png',
                  label: 'التقويم',
                  onTap: () => changePage(3),
                ),
                BottomNavItem(
                  index: 4,
                  currentIndex: currentIndex,
                  iconPath: 'assets/icons/lucide_user.png',
                  label: 'حسابي',
                  onTap: () => changePage(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
