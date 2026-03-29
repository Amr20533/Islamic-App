//
// class HomeView extends StatelessWidget {
//   const HomeView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = locator<PrayerController>();
//
//     return Scaffold(
//       backgroundColor: const Color(0xffE9EFF2),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),
//                 RamadanDashboard(),
//                 // IftarCountdownCard(prayerTimes: PrayerTimes(coordinates, date,params),),
//                 const SizedBox(height: 10),
//                 RamadanStatus(day: 5,),
//                 const SizedBox(height: 10),
//                 Text(
//                   FormatHelper.getMiladFormattedDate(),
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   FormatHelper.getHijriFormattedDate(),
//                   style: TextStyle(
//                     color: Colors.orange,
//                     fontSize: 14,
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 /// Main Prayer Card
//                 Container(
//                   height: 170,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(25),
//                     color: const Color(0xff5D7682),
//                     image: const DecorationImage(
//                       image: AssetImage("assets/desert.png"),
//                       fit: BoxFit.fill,
//                       opacity: 0.3,
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           controller.nextPrayerName.value,
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 18,
//                           ),
//                         ),
//                         SizedBox(height: 6),
//                         Text(
//                           FormatHelper.formatTime12Hour(controller.nextPrayerTime.value),
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 6),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.location_on,
//                                 color: Colors.white70, size: 16),
//                             SizedBox(width: 4),
//                             Text(
//                               "Al Ain, United Arab Emirates",
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 13,
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 25),
//
//                 const Text(
//                   "Prayer times",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//
//                 const SizedBox(height: 15),
//
//                 /// Grid Cards
//                 PrayerGridCards(),
//
//                 const SizedBox(height: 10),
//
//                 /// Daily Duaa Card
//                 Container(
//                   padding: const EdgeInsets.all(18),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: const Color(0xffDDE3E7),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         "Daily Duaa",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         "I ask for forgiveness from Allah, my Lord, "
//                             "from every sin I committed.",
//                         style: TextStyle(fontSize: 13),
//                       ),
//                       SizedBox(height: 6),
//                       Text(
//                         "Second Ashra",
//                         style: TextStyle(
//                           color: Colors.orange,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class PrayerGridCards extends StatelessWidget {
//   const PrayerGridCards({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final RamadanController controller = locator<RamadanController>();
//     return Obx(() {
//       if (controller.prayerTimes.value == null) return const SizedBox();
//
//       return SizedBox(
//         height: 300,
//         child: GridView.count(
//           crossAxisCount: 2,
//           mainAxisSpacing: 15,
//           crossAxisSpacing: 15,
//           physics: const NeverScrollableScrollPhysics(),
//           childAspectRatio: 1.2,
//           children: [
//             PrayerCard(
//               title: "Sahar Time",
//               time: FormatHelper.formatTime12Hour(controller.saharTime),
//               color: Color(0xffDDE3E7),
//               textColor: Colors.black,
//             ),
//             PrayerCard(
//               title: ":الصلاة القادمة\n${controller.nextPrayerName}",
//               time: FormatHelper.formatTime12Hour(controller.nextPrayerTime),
//               color: Color(0xff5D7682),
//               textColor: Colors.white,
//             ),
//             PrayerCard(
//               title: "موعد صلاة\nالعصر",
//               time: FormatHelper.formatTime12Hour(controller.prayerTimes.value?.asr),
//               color: Color(0xffE59A5B),
//               textColor: Colors.white,
//             ),
//             PrayerCard(
//               title: ":موعد الإفطار\nالمغرب",
//               time: FormatHelper.formatTime12Hour(controller.prayerTimes.value?.maghrib),
//               color: Color(0xff7D96A3),
//               textColor: Colors.white,
//             ),
//           ],
//         ),
//       );
//     }
//     );
//   }
// }
