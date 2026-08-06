import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/tasbeeh_cubit.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/tasbeeh_beads_area.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/tasbeeh_counter_display.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/tasbeeh_header.dart';

class ElectronicTasbeehScreen extends StatelessWidget {
  const ElectronicTasbeehScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasbeehCubit()..loadCounter(),
      child: const _ElectronicTasbeehScreenContent(),
    );
  }
}

class _ElectronicTasbeehScreenContent extends StatefulWidget {
  const _ElectronicTasbeehScreenContent();

  @override
  State<_ElectronicTasbeehScreenContent> createState() =>
      _ElectronicTasbeehScreenContentState();
}

class _ElectronicTasbeehScreenContentState
    extends State<_ElectronicTasbeehScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _animationProgress = 0.0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _animationController.addListener(() {
      setState(() => _animationProgress = _animationController.value);
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<TasbeehCubit>().incrementCounter();
        setState(() {
          _animationProgress = 0.0;
          _isAnimating = false;
        });
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    if (_isAnimating) return;
    _isAnimating = true;
    HapticFeedback.lightImpact();
    _animationController.forward();
  }

  void _resetCounterDialog() {
    final cubit = context.read<TasbeehCubit>();
    final state = cubit.state;
    if (state is TasbeehLoaded && state.counter == 0) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFFEDEAE3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              "إعادة ضبط المسبحة",
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D3020),
              ),
            ),
            content: const Text(
              "هل أنت متأكد من رغبتك في إعادة تعيين العداد إلى صفر؟",
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 15,
                color: Color(0xFF8A7560),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "إلغاء",
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8A7560),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  cubit.resetCounter();
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C6D53),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "تأكيد",
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F2EC),
        body: SafeArea(
          child: BlocBuilder<TasbeehCubit, TasbeehState>(
            builder: (context, state) {
              final int counter = state is TasbeehLoaded ? state.counter : 0;

              return Column(
                children: [
                  TasbeehHeader(onReset: _resetCounterDialog),
                  const SizedBox(height: 30),
                  const InstructionText(),
                  const Spacer(flex: 2),
                  TasbeehCounterDisplay(counter: counter),
                  const Spacer(flex: 1),
                  TasbeehBeadsArea(
                    onIncrement: _incrementCounter,
                    animationProgress: _animationProgress,
                  ),
                  const Spacer(flex: 2),
                  const TasbeehFooterText(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class InstructionText extends StatelessWidget {
  const InstructionText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      child: Text(
        "اذكر الله في أي وقت وبأي صيغة تحب.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 16,
          color: Color(0xFF8A7560),
        ),
      ),
    );
  }
}

class TasbeehFooterText extends StatelessWidget {
  const TasbeehFooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 40.0),
      child: Text(
        "إضغط أو اسحب للعد",
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 15,
          color: Color(0xFF8A7560),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}


