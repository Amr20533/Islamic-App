import 'package:flutter/foundation.dart' show kIsWeb;
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

// Breakpoint: screens wider than this are treated as tablet
const double _kTabletBreakpoint = 600.0;

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  late final List<Widget> pages;

  // Nav items definition (shared between phone & tablet)
  static const List<_NavItem> _navItems = [
    _NavItem(icon: 'assets/icons/tabler_home.png', label: 'الرئيسية'),
    _NavItem(icon: 'assets/icons/book.png', label: 'القرآن'),
    _NavItem(icon: 'assets/icons/Tasbeeh.png', label: 'الأذكار'),
    _NavItem(icon: 'assets/icons/calendar.png', label: 'التقويم'),
    _NavItem(icon: 'assets/icons/lucide_user.png', label: 'حسابي'),
  ];

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // On web always use the side-rail layout; on device use breakpoint
          final useSideNav =
              kIsWeb || constraints.maxWidth >= _kTabletBreakpoint;
          return useSideNav
              ? _TabletLayout(
                  pages: pages,
                  navItems: _navItems,
                  currentIndex: currentIndex,
                  onTabSelected: changePage,
                )
              : _PhoneLayout(
                  pages: pages,
                  navItems: _navItems,
                  currentIndex: currentIndex,
                  onTabSelected: changePage,
                );
        },
      ),
    );
  }
}

// ─── Phone Layout ──────────────────────────────────────────────────────────────

class _PhoneLayout extends StatelessWidget {
  const _PhoneLayout({
    required this.pages,
    required this.navItems,
    required this.currentIndex,
    required this.onTabSelected,
  });

  final List<Widget> pages;
  final List<_NavItem> navItems;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            margin: const EdgeInsets.fromLTRB(24, 8, 24, 12),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                width: 1,
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.4),
              ),
              boxShadow: AppShadows.customShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(navItems.length, (i) {
                return BottomNavItem(
                  index: i,
                  currentIndex: currentIndex,
                  iconPath: navItems[i].icon,
                  label: navItems[i].label,
                  onTap: () => onTabSelected(i),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Tablet Layout ─────────────────────────────────────────────────────────────

class _TabletLayout extends StatelessWidget {
  const _TabletLayout({
    required this.pages,
    required this.navItems,
    required this.currentIndex,
    required this.onTabSelected,
  });

  final List<Widget> pages;
  final List<_NavItem> navItems;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            // ── Side Rail ──────────────────────────────────────────────────
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A1815)
                    : theme.colorScheme.surface,
                border: Border(
                  left: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                boxShadow: isDark ? const [] : AppShadows.customShadow,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      // App logo / title at top
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Text(
                          'مآب',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? const Color(0xFFC8A88A)
                                : AppColors.counterColor,
                          ),
                        ),
                      ),
                      // Nav items
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(navItems.length, (i) {
                            return _SideNavItem(
                              icon: navItems[i].icon,
                              label: navItems[i].label,
                              isSelected: currentIndex == i,
                              isDark: isDark,
                              onTap: () => onTabSelected(i),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Page Content ────────────────────────────────────────────────
            Expanded(child: pages[currentIndex]),
          ],
        ),
      ),
    );
  }
}

// ─── Side Nav Item (Tablet) ────────────────────────────────────────────────────

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark
        ? const Color(0xFFC8A88A)
        : AppColors.primaryColor;
    final inactiveIconColor = isDark
        ? const Color(0xFFD4C8BC)
        : AppColors.blackColor;
    final inactiveLabelColor = isDark
        ? const Color(0xFFB8AEA5)
        : const Color(0xFF3E2F25);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                icon,
                width: 22,
                height: 22,
                cacheWidth: 800,
                color: isSelected ? Colors.white : inactiveIconColor,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 280),
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeColor : inactiveLabelColor,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data class ────────────────────────────────────────────────────────────────

class _NavItem {
  final String icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
