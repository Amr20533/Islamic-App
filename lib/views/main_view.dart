import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart' show Obx;
import 'package:islamic_app/core/controllers/main_controller.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/static_files/app_colors.dart';
import 'package:islamic_app/static_files/app_shadows.dart';
import 'package:islamic_app/widgets/home/bottom_nav_item.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final MainController controller = locator<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.pages[controller.currentIndex.value]),

      bottomNavigationBar: Obx(
            () => Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                  margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
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
                  currentIndex: controller.currentIndex.value,
                  iconPath: 'assets/icons/tabler_home.png',
                  label: 'الرئيسية',
                  onTap: () => controller.changePage(0),
                ),
                BottomNavItem(
                  index: 1,
                  currentIndex: controller.currentIndex.value,
                  iconPath: 'assets/icons/book.png',
                  label: 'القرآن',
                  onTap: () => controller.changePage(1),
                ),
                BottomNavItem(
                  index: 2,
                  currentIndex: controller.currentIndex.value,
                  iconPath: 'assets/icons/Tasbeeh.png',
                  label: 'الأذكار',
                  onTap: () => controller.changePage(2),
                ),
                BottomNavItem(
                  index: 3,
                  currentIndex: controller.currentIndex.value,
                  iconPath: 'assets/icons/calendar.png',
                  label: 'التقويم',
                  onTap: () => controller.changePage(3),
                ),
                BottomNavItem(
                  index: 4,
                  currentIndex: controller.currentIndex.value,
                  iconPath: 'assets/icons/dots-horizontal.png',
                  label: 'المزيد',
                  onTap: () => controller.changePage(4),
                ),
              ],
                ),
              ),
            ),
      ),
    );
  }

}
