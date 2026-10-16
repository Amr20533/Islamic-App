import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:islamic_app/core/static_files/app_colors.dart';

/// Custom painter – draws the Qibla compass ring with tick marks, Arabic
/// direction labels, and the golden needle with Kaaba icon.
///
/// When [isOnQibla] is true the needle glows with a light golden halo.
class QiblaCompassPainter extends CustomPainter {
  final double deviceHeading; // degrees from North, clockwise
  final double qiblaBearing;  // degrees from North, clockwise
  final bool isOnQibla;

  const QiblaCompassPainter({
    required this.deviceHeading,
    required this.qiblaBearing,
    this.isOnQibla = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // ── Outer dark ring ──────────────────────────────────────────────────────
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF1A1A1A)
        ..style = PaintingStyle.fill,
    );

    // ── Subtle ring glow when on Qibla ───────────────────────────────────────
    if (isOnQibla) {
      canvas.drawCircle(
        center,
        radius - 2,
        Paint()
          ..color = AppColors.primaryColor.withValues(alpha: 0.18)
          ..style = PaintingStyle.fill,
      );
    }

    // ── Border ────────────────────────────────────────────────────────────────
    canvas.drawCircle(
      center,
      radius - 2,
      Paint()
        ..color = (isOnQibla ? AppColors.primaryColor : AppColors.primaryColor)
            .withValues(alpha: isOnQibla ? 0.7 : 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isOnQibla ? 2.0 : 1.5,
    );

    // ── Ticks + labels (rotate so North is up relative to device) ────────────
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-deviceHeading * math.pi / 180);
    _drawTicksAndLabels(canvas, radius);
    canvas.restore();

    // ── Needle (points to Qibla, independent of compass ring rotation) ────────
    final double needleAngle = (qiblaBearing - deviceHeading) * math.pi / 180;
    _drawNeedle(canvas, center, radius, needleAngle);
  }

  // ── Ticks ──────────────────────────────────────────────────────────────────

  void _drawTicksAndLabels(Canvas canvas, double radius) {
    final tickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    final majorTickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 72; i++) {
      final angle = i * 5 * math.pi / 180;
      final bool isMajor = i % 6 == 0;
      final double tickLen = isMajor ? 12.0 : 6.0;
      final double outerR = radius - 8;
      final double innerR = outerR - tickLen;

      canvas.drawLine(
        Offset(outerR * math.sin(angle), -outerR * math.cos(angle)),
        Offset(innerR * math.sin(angle), -innerR * math.cos(angle)),
        isMajor ? majorTickPaint : tickPaint,
      );
    }

    // ── Cardinal labels (Arabic) ─────────────────────────────────────────────
    const cardinals = ['ش', 'ش.ق', 'ج', 'غ']; // N, E, S, W
    for (int i = 0; i < 4; i++) {
      final angle = i * 90.0 * math.pi / 180;
      final labelR = radius - 30;
      final x = labelR * math.sin(angle);
      final y = -labelR * math.cos(angle);

      final tp = TextPainter(
        text: TextSpan(
          text: cardinals[i],
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            fontFamily: 'Tajawal',
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }
  }

  // ── Needle ─────────────────────────────────────────────────────────────────

  void _drawNeedle(Canvas canvas, Offset center, double radius, double angleRad) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angleRad);

    final Color needleColor =
        isOnQibla ? const Color(0xFFFFD700) : AppColors.primaryColor;

    // Glow when on Qibla
    if (isOnQibla) {
      canvas.drawLine(
        const Offset(0, 0),
        Offset(0, -(radius * 0.58)),
        Paint()
          ..color = const Color(0xFFFFD700).withValues(alpha: 0.35)
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // Needle line
    canvas.drawLine(
      const Offset(0, 0),
      Offset(0, -(radius * 0.58)),
      Paint()
        ..color = needleColor
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // Centre dot
    canvas.drawCircle(
      Offset.zero,
      6,
      Paint()..color = needleColor,
    );

    // Kaaba icon at needle base
    _drawKaabaIcon(canvas, radius, needleColor);

    canvas.restore();
  }

  // ── Kaaba icon ─────────────────────────────────────────────────────────────

  void _drawKaabaIcon(Canvas canvas, double radius, Color color) {
    final double iconY = radius * 0.55;

    // Shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(0, iconY), width: 28, height: 28),
        const Radius.circular(5),
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(0, iconY), width: 28, height: 28),
        const Radius.circular(5),
      ),
      Paint()..color = color,
    );

    // Belt line
    canvas.drawLine(
      Offset(-13, iconY - 2),
      Offset(13, iconY - 2),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.85)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke,
    );

    // Door
    canvas.drawRect(
      Rect.fromCenter(center: Offset(0, iconY + 5), width: 6, height: 9),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(QiblaCompassPainter old) =>
      old.deviceHeading != deviceHeading ||
      old.qiblaBearing != qiblaBearing ||
      old.isOnQibla != isOnQibla;
}
