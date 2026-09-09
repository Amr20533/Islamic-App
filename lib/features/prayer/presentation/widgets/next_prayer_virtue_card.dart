import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_cubit.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/prayer_state.dart';

class NextPrayerVirtueCard extends StatelessWidget {
  const NextPrayerVirtueCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242220) : null,
        borderRadius: BorderRadius.circular(10),
        border: isDark
            ? Border.all(color: const Color(0xFF383430), width: 1)
            : null,
        image: DecorationImage(
          image: const ResizeImage(
            width: 800,
            AssetImage(
              'assets/images/Gemini_Generated_Image_1vp5pk1vp5pk1vp5 (1) 1.png',
            ),
          ),
          fit: BoxFit.cover,
          colorFilter: isDark
              ? ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.75),
                  BlendMode.darken,
                )
              : null,
        ),
        boxShadow: isDark
            ? const []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<PrayerCubit, PrayerState>(
          builder: (context, state) {
            final nextPrayerName = state is PrayerLoaded
                ? state.nextPrayerName
                : '...';

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الصلاة القادمة',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFC8A88A) : AppColors.counterColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFFC8A88A).withOpacity(0.15)
                            : AppColors.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        nextPrayerName,
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: isDark ? const Color(0xFF383430) : AppColors.borderColor,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'فضل الصلاة في وقتها:',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? const Color(0xFFF5F2EE) : AppColors.counterColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'عن ابن مسعود رضي الله عنه قال: سألت رسول الله صلى الله عليه وسلم: أي العمل أحب إلى الله؟ قال: «الصلاة على وقتها». (رواه البخاري ومسلم)',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark ? const Color(0xFFB8AEA5) : AppColors.primaryTextColor,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
