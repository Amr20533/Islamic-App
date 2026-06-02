import 'package:flutter/material.dart';

class TasbeehBeadsPainter extends CustomPainter {
  final double progress;

  TasbeehBeadsPainter({required this.progress});

  Offset _getPointOnCurve(double t, Size size) {
    final p0 = Offset(-40, size.height * 0.4);
    final p1 = Offset(size.width * 0.42, size.height * 0.05);
    final p2 = Offset(size.width + 40, size.height * 0.72);

    double x =
        (1 - t) * (1 - t) * p0.dx + 2 * (1 - t) * t * p1.dx + t * t * p2.dx;
    double y =
        (1 - t) * (1 - t) * p0.dy + 2 * (1 - t) * t * p1.dy + t * t * p2.dy;
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF8A7560).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final startPt = _getPointOnCurve(0.0, size);
    path.moveTo(startPt.dx, startPt.dy);

    for (double t = 0.01; t <= 1.0; t += 0.01) {
      final pt = _getPointOnCurve(t, size);
      path.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(path, linePaint);

    const double spacing = 0.22;
    const double baseBeadRadius = 32.0;

    for (int i = -1; i <= 5; i++) {
      double t = (i * spacing) - (progress * spacing) + 0.15;

      if (t < -0.1 || t > 1.1) continue;

      final beadCenter = _getPointOnCurve(t, size);

      final beadPaint = Paint()
        ..shader =
            RadialGradient(
              colors: const [
                Color(0xFF91725A),
                Color(0xFF6B5040),
                Color(0xFF423026),
              ],
              stops: const [0.0, 0.65, 1.0],
              center: const Alignment(-0.25, -0.25),
              radius: 0.85,
            ).createShader(
              Rect.fromCircle(center: beadCenter, radius: baseBeadRadius),
            );

      canvas.drawCircle(
        beadCenter.translate(0, 4),
        baseBeadRadius,
        Paint()
          ..color = Colors.black.withOpacity(0.08)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );

      canvas.drawCircle(beadCenter, baseBeadRadius, beadPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TasbeehBeadsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
