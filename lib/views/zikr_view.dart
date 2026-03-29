import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/core/controllers/azkar_controller.dart';
import 'package:islamic_app/core/models/azkar/azkar_category.dart';
import 'package:islamic_app/di/locator.dart';

import 'azkar_details_screen.dart';

class ZikrView extends StatelessWidget {
  const ZikrView({super.key});

  @override
  Widget build(BuildContext context) {
    final AzkarController controller = locator<AzkarController>();

    return ListView.builder(
      itemCount: AzkarCategory.azkar.length,
      itemBuilder: (context, index) {
        final cat = AzkarCategory.azkar[index];
        return ListTile(
          title: Text(cat.title, textAlign: TextAlign.right),
          trailing: Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () {
            controller.loadZikrDetails(cat.id);
            Get.to(() => AzkarDetailScreen(title: cat.title));
          },
        );
      },
    );
  }
}