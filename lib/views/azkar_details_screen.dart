import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/core/controllers/azkar_controller.dart';
import 'package:islamic_app/di/locator.dart';

class AzkarDetailScreen extends StatelessWidget {
  final String title;
  const AzkarDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final AzkarController controller = locator<AzkarController>();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Obx(() {
        if (controller.isLoading.value) return Center(child: CircularProgressIndicator());

        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: controller.currentZikrList.length,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder: (context, index) {
            final item = controller.currentZikrList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.arabicText,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18, height: 1.5),
                ),
                SizedBox(height: 10),
                Chip(
                  label: Text("التكرار: ${item.repeat}"),
                  backgroundColor: Colors.blueGrey.withOpacity(0.1),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}