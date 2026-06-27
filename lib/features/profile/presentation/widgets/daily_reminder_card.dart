import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_state.dart';

class DailyReminderCard extends StatelessWidget {
  const DailyReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor2, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final isEnabled = state is ProfileLoaded
                ? state.isDailyReminderEnabled
                : false;
            final reminderTime = state is ProfileLoaded
                ? state.dailyReminderTime
                : '08:00 AM';

            return Column(
              children: [
                // Toggle row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/svg/ph_plant.svg"),
                          const SizedBox(width: 8),
                          const Text(
                            'التذكير اليومي',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Transform.scale(
                        scale: 0.85,
                        alignment: Alignment.centerRight,
                        child: Switch(
                          value: isEnabled,
                          onChanged: (val) => context
                              .read<ProfileCubit>()
                              .toggleDailyReminder(val),
                          activeThumbColor: AppColors.whiteColor,
                          activeTrackColor: AppColors.successColor800,
                          inactiveThumbColor: AppColors.greyColor,
                          inactiveTrackColor: AppColors.lightGreyColor,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),

                // Time picker row
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final cubit = context.read<ProfileCubit>();
                    // Parse current saved time to use as initial time
                    final currentState = cubit.state;
                    TimeOfDay initialTime = const TimeOfDay(hour: 8, minute: 0);
                    if (currentState is ProfileLoaded) {
                      initialTime = cubit.parseTimeForDisplay(
                        currentState.dailyReminderTime,
                      );
                    }
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: initialTime,
                      builder: (context, child) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      // Update time and auto-enable the reminder
                      await cubit.updateReminderTime(picked);
                      if (!(cubit.state is ProfileLoaded &&
                          (cubit.state as ProfileLoaded)
                              .isDailyReminderEnabled)) {
                        await cubit.toggleDailyReminder(true);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/hugeicons_date-time.svg",
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'وقت التذكير',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        // Time badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.borderColor3,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppColors.borderColor2,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                reminderTime,
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 17,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
