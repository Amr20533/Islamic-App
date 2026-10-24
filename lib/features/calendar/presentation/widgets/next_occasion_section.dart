import 'dart:async';
import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/helpers/islamic_occasion_helper.dart';
import 'islamic_occasion_card.dart';

class NextOccasionSection extends StatefulWidget {
  final int dayAdjustment;
  const NextOccasionSection({super.key, this.dayAdjustment = 0});

  @override
  State<NextOccasionSection> createState() => _NextOccasionSectionState();
}

class _NextOccasionSectionState extends State<NextOccasionSection>
    with WidgetsBindingObserver {
  late OccasionResult _result;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _result = _compute();
    _scheduleMidnight();
  }

  OccasionResult _compute() => IslamicOccasionHelper.getNextOccasion(
        dayAdjustment: widget.dayAdjustment,
      );

  void _refresh() {
    if (!mounted) return;
    setState(() => _result = _compute());
    _scheduleMidnight();
  }

  void _scheduleMidnight() {
    _timer?.cancel();
    final now = DateTime.now();
    final next = DateTime(now.year, now.month, now.day + 1);
    _timer = Timer(next.difference(now) + const Duration(seconds: 1), _refresh);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  @override
  void didUpdateWidget(covariant NextOccasionSection old) {
    super.didUpdateWidget(old);
    if (old.dayAdjustment != widget.dayAdjustment) _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IslamicOccasionCard(result: _result);
}