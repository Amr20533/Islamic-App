import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/ramadan/presentation/bloc/ramadan_cubit.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/features/ramadan/presentation/widgets/prayer_card.dart';

class PrayerGridCards extends StatelessWidget {
  const PrayerGridCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamadanCubit, RamadanState>(
      builder: (context, state) {
        if (state is! RamadanLoaded) return const SizedBox();

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
                time: FormatHelper.formatTime12Hour(state.saharTime),
                color: const Color(0xffDDE3E7),
                textColor: Colors.black,
              ),
              PrayerCard(
                title: ":الصلاة القادمة\n${state.nextPrayerName}",
                time: FormatHelper.formatTime12Hour(state.nextPrayerTime),
                color: const Color(0xff5D7682),
                textColor: Colors.white,
              ),
              PrayerCard(
                title: "موعد صلاة\nالعصر",
                time: FormatHelper.formatTime12Hour(state.prayerTimes.asr),
                color: const Color(0xffE59A5B),
                textColor: Colors.white,
              ),
              PrayerCard(
                title: ":موعد الإفطار\nالمغرب",
                time: FormatHelper.formatTime12Hour(state.prayerTimes.maghrib),
                color: const Color(0xff7D96A3),
                textColor: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
