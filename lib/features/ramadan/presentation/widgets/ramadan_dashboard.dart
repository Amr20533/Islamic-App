import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/ramadan/presentation/bloc/ramadan_cubit.dart';
import 'iftar_count_down_card.dart';

class RamadanDashboard extends StatelessWidget {
  const RamadanDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamadanCubit, RamadanState>(
      builder: (context, state) {
        if (state is RamadanLoading) {
          return const CircularProgressIndicator(color: Color(0xFF38BDF8));
        }

        if (state is RamadanError) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Error: ${state.message}",
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () =>
                    context.read<RamadanCubit>().fetchPrayerTimes(),
                child: const Text("Retry"),
              ),
            ],
          );
        }

        if (state is RamadanLoaded) {
          return IftarCountdownCard(prayerTimes: state.prayerTimes);
        }

        return const SizedBox();
      },
    );
  }
}
