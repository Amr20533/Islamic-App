import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/features/home/presentation/widgets/daily_plan_card.dart';
import 'package:islamic_app/features/home/presentation/widgets/home_header.dart';
import 'package:islamic_app/features/home/presentation/widgets/progress_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HomeHeader(),

                SizedBox(
                  height: (MediaQuery.sizeOf(context).height * 0.035)
                      .clamp(8.0, 14.0),
                ),
                IntrinsicHeight(
                  child: SizedBox(
                    width: 264,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          FormatHelper.getMiladFormattedDate(),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        VerticalDivider(
                          width: 24,
                          thickness: 0.5,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        Text(
                          FormatHelper.getHijriFormattedDate(),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                        Text(
                          "\"أحبُّ الأعمالِ إلى اللهِ أدومُها وإن قلَّ\"",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: (MediaQuery.sizeOf(context).width * 0.045).clamp(10.0, 20.0),
                      ),
                      textAlign: TextAlign.center),
                      SizedBox(
                          height: (MediaQuery.sizeOf(context).height * 0.04).clamp(16.0, 32.0),
                        ),                           const DailyPlanCard(),
                        SizedBox(height: MediaQuery.sizeOf(context).height * 0.050),                        
                        const ProgressCard(
                          icon: 'assets/icons/progress.png',
                          leading: 'استمرارك ',
                        ),
                        // const SizedBox(height: 61),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
