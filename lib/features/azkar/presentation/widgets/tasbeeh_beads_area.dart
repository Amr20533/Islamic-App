import 'package:flutter/material.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/tasbeeh_beads_painter.dart';

class TasbeehBeadsArea extends StatefulWidget {
  final VoidCallback onIncrement;
  final double animationProgress;

  const TasbeehBeadsArea({
    super.key,
    required this.onIncrement,
    required this.animationProgress,
  });

  @override
  State<TasbeehBeadsArea> createState() => _TasbeehBeadsAreaState();
}

class _TasbeehBeadsAreaState extends State<TasbeehBeadsArea> {
  double _dragDistance = 0.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _dragDistance += details.primaryDelta ?? 0.0;
    if (_dragDistance < -15.0) {
      _dragDistance = 0.0;
      widget.onIncrement();
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _dragDistance = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onIncrement,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: SizedBox(
        width: double.infinity,
        height: 280,
        child: CustomPaint(
          painter: TasbeehBeadsPainter(progress: widget.animationProgress),
        ),
      ),
    );
  }
}
