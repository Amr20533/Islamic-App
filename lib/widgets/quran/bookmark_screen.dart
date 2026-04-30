import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/core/controllers/azkar_controller.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/services/extensions/theme_extension.dart';
import 'package:islamic_app/static_files/app_colors.dart';
import 'package:islamic_app/static_files/app_text_styles.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AzkarController controller = locator<AzkarController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightGreyColor,
        appBar: AppBar(
          backgroundColor: AppColors.lightGreyColor,
          leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_sharp, color: context.primaryColor, size: 18,),
          ),
          title: Text("علامات الحفظ", style: AppTextStyles.textTheme.titleLarge,),
        ),
        body: Column(
          children: [

          ],
        )
      ),
    );
  }
}

class EmptyBookmark extends StatelessWidget {
  const EmptyBookmark({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("لا توجد علامات محفوظة بعد", style: AppTextStyles.textTheme.labelMedium!.copyWith(fontSize: 16),),
          Text("ابدأ بحفظ الصفحات التي تريد الرجوع إليها 🌱", style: AppTextStyles.textTheme.labelMedium!.copyWith(fontSize: 16),),
        ],
      ),
    );
  }
}