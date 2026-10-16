import 'package:flutter/material.dart';
import 'package:islamic_app/features/qibla/presentation/widgets/qibla_compass_painter.dart';

/// Animated compass widget.
/// Uses an [AnimationController] to smoothly interpolate between headings
/// along the *shortest angular path* — no wrap-around flips.
class QiblaCompassWidget extends StatefulWidget {
  final double qiblaBearing;
  final double deviceHeading;
  final bool isOnQibla;

  const QiblaCompassWidget({
    super.key,
    required this.qiblaBearing,
    required this.deviceHeading,
    this.isOnQibla = false,
  });

  @override
  State<QiblaCompassWidget> createState() => _QiblaCompassWidgetState();
}

class _QiblaCompassWidgetState extends State<QiblaCompassWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _headingAnim;

  /// The heading value we are animating FROM (accumulated, may exceed 360).
  double _accumulatedHeading = 0;

  @override
  void initState() {
    super.initState();
    _accumulatedHeading = widget.deviceHeading;

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _headingAnim = AlwaysStoppedAnimation(_accumulatedHeading);
  }

  @override
  void didUpdateWidget(QiblaCompassWidget old) {
    super.didUpdateWidget(old);

    if (old.deviceHeading == widget.deviceHeading) return;

    // Current animated value (may be outside 0-360, that's OK)
    final double from = _headingAnim.value;

    // Shortest angular path from 'from' to new target
    double diff = (widget.deviceHeading - from) % 360;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;

    final double to = from + diff;
    _accumulatedHeading = to;

    _headingAnim = Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward(from: 0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _headingAnim,
      builder: (_, __) {
        return SizedBox(
          width: 280,
          height: 280,
          child: CustomPaint(
            painter: QiblaCompassPainter(
              deviceHeading: _headingAnim.value % 360,
              qiblaBearing: widget.qiblaBearing,
              isOnQibla: widget.isOnQibla,
            ),
          ),
        );
      },
    );
  }
}
