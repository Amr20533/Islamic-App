import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/features/profile/presentation/widgets/settings_option_row.dart';
import 'package:islamic_app/features/profile/presentation/pages/account_management_view.dart';
import 'package:islamic_app/features/profile/presentation/pages/report_problem_view.dart';
import 'package:islamic_app/features/profile/presentation/pages/rate_app_view.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? const Color(0xFFC8A88A)
        : AppColors.primaryColor;
    final labelColor = isDark
        ? const Color(0xFFF5F2EE)
        : AppColors.primaryColor;
    final dividerColor = isDark
        ? const Color(0xFF383430)
        : AppColors.borderColor;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242220) : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF383430) : AppColors.borderColor2,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SettingsOptionRow(
            svgPath: 'assets/icons/user.svg',
            label: 'إدارة الحساب',
            labelColor: labelColor,
            iconColor: primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AccountManagementView(),
                ),
              );
            },
          ),
          Divider(height: 1, thickness: 0.5, color: dividerColor),
          SettingsOptionRow(
            svgPath: 'assets/svg/proicons_bell.svg',
            label: 'تنبيهات الصلاة',
            onTap: () => Navigator.pushNamed(context, AppRoutes.alarms),
            labelColor: labelColor,
            iconColor: primaryColor,
          ),
          Divider(height: 1, thickness: 0.5, color: dividerColor),
          SettingsOptionRow(
            icon: Icons.report_outlined,
            label: 'الابلاغ عن مشكلة',
            labelColor: labelColor,
            iconColor: primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportProblemView()),
              );
            },
          ),
          Divider(height: 1, thickness: 0.5, color: dividerColor),
          SettingsOptionRow(
            icon: Icons.star_outline_rounded,
            label: 'تقيم التطبيق',
            labelColor: labelColor,
            iconColor: primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RateAppView()),
              );
            },
          ),
          Divider(height: 1, thickness: 0.5, color: dividerColor),
          // ── Theme Selector Row ─────────────────────────────────────────────
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              final String themeName;
              switch (themeState.appThemeMode) {
                case AppThemeMode.dark:
                  themeName = 'داكن';
                  break;
                case AppThemeMode.light:
                  themeName = 'فاتح';
                  break;
                case AppThemeMode.system:
                  themeName = 'تلقائي';
                  break;
              }
              return GestureDetector(
                onTap: () => _showThemeDialog(context),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.dark_mode_outlined,
                            size: 20,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المظهر',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: labelColor,
                                ),
                              ),
                              Text(
                                themeName,
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? const Color(0xFFB8AEA5)
                                      : AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: isDark
                            ? const Color(0xFFB8AEA5)
                            : AppColors.greyColor,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Shows a bottom sheet for picking the app theme (Light / Dark / System).
void _showThemeDialog(BuildContext context) {
  final cubit = context.read<ThemeCubit>();
  final current = cubit.state.appThemeMode;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    backgroundColor: isDark ? const Color(0xFF211F1D) : null,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اختر المظهر',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFFF5F2EE)
                        : AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                _ThemeOptionTile(
                  icon: Icons.light_mode_outlined,
                  label: 'فاتح',
                  mode: AppThemeMode.light,
                  current: current,
                ),
                _ThemeOptionTile(
                  icon: Icons.dark_mode_outlined,
                  label: 'داكن',
                  mode: AppThemeMode.dark,
                  current: current,
                ),
                _ThemeOptionTile(
                  icon: Icons.brightness_auto_outlined,
                  label: 'تلقائي (حسب النظام)',
                  mode: AppThemeMode.system,
                  current: current,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppThemeMode mode;
  final AppThemeMode current;

  const _ThemeOptionTile({
    required this.icon,
    required this.label,
    required this.mode,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == current;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? const Color(0xFFC8A88A)
        : AppColors.primaryColor;
    final textColor = isDark
        ? const Color(0xFFF5F2EE)
        : AppColors.primaryTextColor;
    final greyColor = isDark ? const Color(0xFFB8AEA5) : AppColors.greyColor;

    return InkWell(
      onTap: () {
        context.read<ThemeCubit>().setThemeMode(mode);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 22, color: isSelected ? primaryColor : greyColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? textColor : greyColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, size: 20, color: primaryColor),
          ],
        ),
      ),
    );
  }
}
