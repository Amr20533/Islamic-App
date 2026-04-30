import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/core/controllers/quran/surah_selection_controller.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/static_files/app_colors.dart';
import 'package:islamic_app/static_files/app_routes.dart';
import 'package:islamic_app/static_files/app_text_styles.dart';
import 'package:islamic_app/widgets/default/app_primary_button.dart';
import 'package:islamic_app/widgets/quran/custom_surah_selector.dart';

// 1. القائمة الرئيسية للسور
class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {

    // final controller = locator<QuranController>();
    final SurahSelectorController controller = locator<SurahSelectorController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightGreyColor,
        appBar: AppBar(
          backgroundColor: AppColors.lightGreyColor,
          leading: Container(),
          title: Text("القران", style: AppTextStyles.textTheme.titleLarge,),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 24),
              child: GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.bookmark);
                },
                child: Image.asset("assets/icons/Vector (9).png", width: 18,height: 24,),
              ),
            )
          ],
        ),

        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              spacing: 20,
              children: [
                Container(
                  width: double.infinity,
                  height: 132,
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  decoration: BoxDecoration(
                    color: AppColors.authCardBorderColor,
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: AssetImage('assets/images/quran_banner_1.png'),
                        fit: BoxFit.fill,
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      Column(
                        spacing: 2,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("تابع من حيث توقفت", style: AppTextStyles.textTheme.labelMedium!.copyWith(fontSize: 20,),),
                          Text("سورة البقرة • صفحة 12", style: AppTextStyles.textTheme.titleMedium,),
                        ],
                      ),
                      AppPrimaryButton(
                        onPressed: (){},
                        width: 100,
                        height: 30,
                        fontSize:14,
                        radius: 4,
                        label: 'متابعة',
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    border: Border.all(color: AppColors.borderColor, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ابحث عن سورة أو آية ...", style: AppTextStyles.textTheme.titleSmall,),
                      Image.asset('assets/icons/iconoir_search.png'),
                    ],
                  ),
                ),
                CustomSurahSelector(),
                Obx(() {
                    return DefaultTabController(length: controller.categories.length, child: controller.pages[controller.selectedIndex]);
                  }
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}



/*
class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم Get.find لأننا غالباً قمنا بحقن الكنترولر في البداية
    final controller = locator<QuranController>();

    return ListView.builder(
      itemCount: SurahCategory.surahCategories.length,
      itemBuilder: (context, index) {
        final cat = SurahCategory.surahCategories[index];
        return ListTile(
          title: Text(cat.name, textAlign: TextAlign.right),
          subtitle: Text("سورة رقم ${index + 1}", textAlign: TextAlign.right, style: const TextStyle(fontSize: 10)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () async {
            // تحميل البيانات قبل الانتقال لضمان تجربة مستخدم سلسة
            await controller.loadSurahData(index + 1);
            Get.to(() => SurahDetailsView(surahName: cat.name));
          },
        );
      },
    );
  }
}

 */