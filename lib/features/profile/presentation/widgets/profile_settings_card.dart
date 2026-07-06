import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/features/profile/presentation/widgets/settings_option_row.dart';
import 'package:islamic_app/features/profile/presentation/pages/account_management_view.dart';
import 'package:islamic_app/features/profile/presentation/pages/report_problem_view.dart';
import 'package:islamic_app/features/profile/presentation/pages/rate_app_view.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor2, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SettingsOptionRow(
            svgPath: 'assets/icons/user.svg',
            label: 'إدارة الحساب',
            labelColor: AppColors.primaryColor,
            iconColor: AppColors.primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AccountManagementView(),
                ),
              );
            },
          ),
          const Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.borderColor,
          ),
          SettingsOptionRow(
            svgPath: 'assets/svg/proicons_bell.svg',
            label: 'تنبيهات الصلاة',
            onTap: () => Navigator.pushNamed(context, AppRoutes.alarms),
            labelColor: AppColors.primaryColor,
            iconColor: AppColors.primaryColor,
          ),
          const Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.borderColor,
          ),
          SettingsOptionRow(
            icon: Icons.report_outlined,
            label: 'الابلاغ عن مشكلة',
            labelColor: AppColors.primaryColor,
            iconColor: AppColors.primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReportProblemView(),
                ),
              );
            },
          ),
          const Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.borderColor,
          ),
          SettingsOptionRow(
            icon: Icons.star_outline_rounded,
            label: 'تقيم التطبيق',
            labelColor: AppColors.primaryColor,
            iconColor: AppColors.primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RateAppView(),
                ),
              );
            },
          ),
          const Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.borderColor,
          ),
          SettingsOptionRow(
            icon: Icons.logout_rounded,
            label: 'تسجيل الخروج',
            labelColor: AppColors.primaryColor,
            iconColor: AppColors.primaryColor,
            onTap: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.login),
          ),
        ],
      ),
    );
  }
}
