import 'package:flutter/material.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:islamic_app/services/notification_service.dart';
import '../core/controllers/adhan_controller.dart';

class AdanView extends StatelessWidget {
  AdanView({super.key});

  // استدعاء الكنترولر المسؤول عن الأذان
  final AdhanController adhanController = locator<AdhanController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_active, size: 100, color: Colors.teal),
            const SizedBox(height: 20),
            const Text(
              "نظام تنبيه الأذان",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // زر للتجربة الفورية
            ElevatedButton(
              onPressed: () {

                // NotificationService().scheduleNotification(
                //   id: 16,
                //   title: 'حان الآن موعد أذان',
                //     scheduledTime: DateTime.now().add(const Duration(seconds: 5)),
                //     body: 'حي على الصلاة، حي على الفلاح',
                // );                // adhanController.playAdhan("العصر");
                // adhanController.scheduleNotification('الفجر', DateTime.now().add(const Duration(seconds: 5)));
                adhanController.playAdhan("العصر");
              },
              child: const Text("تشغيل تجريبي"),
            ),
          ],
        ),
      ),
    );
  }
}
// class AdanView extends StatelessWidget {
//   AdanView({super.key});
//
//   final AudioController controller = locator<AudioController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
// // Inside your Column in AdanView
//         Obx(() {
//           final double maxVal = controller.duration.value.inSeconds.toDouble();
//           final double currentVal = controller.position.value.inSeconds.toDouble();
//
//           return Slider(
//             min: 0,
//             // Ensure max is never 0 or less than currentVal
//             max: maxVal > 0 ? maxVal : 1.0,
//             value: currentVal.clamp(0.0, maxVal > 0 ? maxVal : 1.0),
//             activeColor: Colors.green,
//             inactiveColor: Colors.grey,
//             onChanged: (value) {
//               // Seek to the new position
//               controller.seek(Duration(seconds: value.toInt()));
//             },
//           );
//         }),
//         Obx(() => ElevatedButton.icon(
//           onPressed: () {
//             if (controller.isPlaying.value) {
//               controller.pause();
//             } else {
//               controller.playNetwork('https://server10.mp3quran.net/ajm/128/012.mp3');
//             }
//           },
//           icon: Icon(controller.isPlaying.value ? Icons.pause : Icons.play_arrow),
//           label: Text(controller.isPlaying.value ? "Pause" : "Play Adhan"),
//         )),
//       ],
//     );
//   }
// }