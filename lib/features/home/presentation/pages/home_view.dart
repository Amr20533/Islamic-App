import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/features/home/presentation/widgets/daily_plan_card.dart';
import 'package:islamic_app/features/home/presentation/widgets/progress_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_cubit.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  spacing: 12,
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/avatar_1.jpg"),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "السلام عليكم، عمر",
                          style: AppTextStyles.textTheme.titleLarge!.copyWith(
                            height: 1.2,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 3,
                          children: [
                            Text(
                              "جميل أنك عدت اليوم",
                              style: AppTextStyles.textTheme.labelMedium,
                            ),
                            Image.asset(
                              "assets/icons/like.png",
                              width: 16,
                              height: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              IntrinsicHeight(
                child: SizedBox(
                  width: 264,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        FormatHelper.getMiladFormattedDate(),
                        style: AppTextStyles.textTheme.labelMedium,
                      ),
                      const VerticalDivider(
                        width: 24,
                        thickness: 0.5,
                        color: AppColors.primaryColor,
                      ),
                      Text(
                        FormatHelper.getHijriFormattedDate(),
                        style: AppTextStyles.textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      BlocBuilder<PrayerCubit, PrayerState>(
                        builder: (context, state) {
                          if (state is PrayerLoaded) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 8,
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: AppColors.primaryColor,
                                        size: 20,
                                      ),
                                      Text(
                                        "الصلاة القادمة: ${state.nextPrayerName}",
                                        style: AppTextStyles
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color:
                                                  AppColors.secondaryTextColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.countdown,
                                    style: AppTextStyles.textTheme.displayLarge!
                                        .copyWith(
                                          fontSize: 25,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                          fontFamily: 'Tajawal',
                                        ),
                                  ),
                                  Text(
                                    "الوقت المتبقي",
                                    style: AppTextStyles.textTheme.labelSmall!
                                        .copyWith(
                                          color: AppColors.hintTextColor,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox(height: 100);
                        },
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "\"أحبُّ الأعمالِ إلى اللهِ أدومُها وإن قلَّ\"",
                        style: AppTextStyles.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      const DailyPlanCard(),
                      const SizedBox(height: 40),
                      const ProgressCard(
                        icon: 'assets/icons/progress.png',
                        leading: 'استمرارك ',
                        trailing: '12 يوم',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// 3. Simple Placeholder for when data is null



// class HomeView extends StatelessWidget {
//   HomeView({super.key});
//
//   final AudioController controller = locator<AudioController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // ElevatedButton(
//           //   onPressed: () async {
//           //     await NotificationService().showNotification(
//           //       id: 1,
//           //       title: 'موعد الأذان',
//           //       body: 'حان الان موعد اذان العصر',
//           //     );
//           //     Future.delayed(Duration(seconds: 1), (){
//           //       controller.playAsset('audio/adhan.mp3');
//           //     });
//           //
//           //   },
//           //   child: const Text('Show Notification'),
//           // ),
//           ElevatedButton(
//             onPressed: () async {
//               // Access the ALREADY INITIALIZED service
//               final notificationService = locator<NotificationService>();
//
//               await notificationService.scheduleNotification(
//                 id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
//                 title: 'موعد الأذان',
//                 body: 'حان الان موعد اذان الظهر',
//                 scheduledTime: DateTime.now().add(const Duration(seconds: 10)),
//               );
//             },
//             child: const Text('Scheduled Notification'),
//           ),
//         ],
//       ),
//     );
//   }
//
// }