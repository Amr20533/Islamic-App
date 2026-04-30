import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/core/controllers/azkar_controller.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/services/extensions/theme_extension.dart';
import 'package:islamic_app/static_files/app_colors.dart';
import 'package:islamic_app/static_files/app_text_styles.dart';

class AzkarDetailScreen extends StatelessWidget {
  final String title;
  const AzkarDetailScreen({super.key, required this.title});

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
          title: Text(title, style: AppTextStyles.textTheme.titleLarge,),
        ),
        body: Obx(() {
          if (controller.isLoading.value) return Center(child: CircularProgressIndicator());

          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: controller.currentZikrList.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final item = controller.currentZikrList[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.arabicText,
                    textAlign: TextAlign.justify,
                    style: AppTextStyles.textTheme.bodyLarge!.copyWith(height: 1.2),
                    // style: TextStyle(fontSize: 18, height: 1.5),
                  ),
                  SizedBox(height: 10),
                  Chip(
                    label: Text("التكرار: ${item.repeat}"),
                    backgroundColor: AppColors.thirdColor,
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}