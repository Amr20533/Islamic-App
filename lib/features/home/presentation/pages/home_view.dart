import 'dart:io';
import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/features/auth/cubit/user_profile_cubit.dart';
import 'package:islamic_app/features/auth/cubit/user_profile_states.dart';
import 'package:islamic_app/features/home/presentation/widgets/daily_plan_card.dart';
import 'package:islamic_app/features/home/presentation/widgets/progress_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_state.dart';

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
              BlocBuilder<UserProfileCubit, UserProfileState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Text(
                      'يتم تحميل البيانات...',
                      style: AppTextStyles.textTheme.titleLarge!.copyWith(
                        height: 1.2,
                      ),
                    );
                  }

                  final name = state.user?.fullName ?? '';

                  final greetingText = name.isNotEmpty ? "السلام عليكم، $name" : "السلام عليكم";

                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage("assets/images/avatar_1.jpg"),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                greetingText,
                                style: AppTextStyles.textTheme.titleLarge!.copyWith(
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 4),

                              Row(
                                children: [
                                  Text(
                                    "جميل أنك عدت اليوم",
                                    style: AppTextStyles.textTheme.labelMedium,
                                  ),

                                  const SizedBox(width: 3),

                                  Image.asset(
                                    "assets/icons/like.png",
                                    width: 16,
                                    height: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  );
                },
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

              Column(
                children: [
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