import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_app/core/controllers/ramadan_controller.dart';
import 'package:islamic_app/services/helpers/format_helper.dart';
import 'package:islamic_app/widgets/home/prayer_card.dart';

import '../../di/locator.dart';

class PrayerGridCards extends StatelessWidget {
  const PrayerGridCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RamadanController controller = locator<RamadanController>();
    return Obx(() {
      if (controller.prayerTimes.value == null) return const SizedBox();

      return SizedBox(
        height: 300,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.2,
          children: [
            PrayerCard(
              title: "Sahar Time",
              time: FormatHelper.formatTime12Hour(controller.saharTime),
              color: Color(0xffDDE3E7),
              textColor: Colors.black,
            ),
            PrayerCard(
              title: ":الصلاة القادمة\n${controller.nextPrayerName}",
              time: FormatHelper.formatTime12Hour(controller.nextPrayerTime),
              color: Color(0xff5D7682),
              textColor: Colors.white,
            ),
            PrayerCard(
              title: "موعد صلاة\nالعصر",
              time: FormatHelper.formatTime12Hour(controller.prayerTimes.value?.asr),
              color: Color(0xffE59A5B),
              textColor: Colors.white,
            ),
            PrayerCard(
              title: ":موعد الإفطار\nالمغرب",
              time: FormatHelper.formatTime12Hour(controller.prayerTimes.value?.maghrib),
              color: Color(0xff7D96A3),
              textColor: Colors.white,
            ),
          ],
        ),
      );
    }
    );
  }
}
