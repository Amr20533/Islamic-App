import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/core/controllers/ramadan_controller.dart';
import 'package:islamic_app/di/locator.dart';

import 'iftar_count_down_card.dart';

class RamadanDashboard extends StatelessWidget {
  const RamadanDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final RamadanController controller = locator<RamadanController>();

    return Obx(() {
      // 1. Loading State
      if (controller.isLoading.value) {
        return const CircularProgressIndicator(color: Color(0xFF38BDF8));
      }

      // 2. Error State
      if (controller.errorMessage.value.isNotEmpty) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Error: ${controller.errorMessage.value}",
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: controller.fetchPrayerTimes,
              child: const Text("Retry"),
            )
          ],
        );
      }

      // 3. Success State
      if (controller.prayerTimes.value != null) {
        return IftarCountdownCard(
          prayerTimes: controller.prayerTimes.value!,
        );
      }

      return const SizedBox();
    });
  }
}
