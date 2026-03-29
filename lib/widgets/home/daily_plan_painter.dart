import 'package:flutter/material.dart';
import 'package:islamic_app/static_files/app_colors.dart';

class DailyPlanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = 24.0; // Matches your card's corner radius

    // 1. Define the base card shape
    RRect outerRRect = RRect.fromLTRBAndCorners(
      0, 0, size.width, size.height,
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );

    // 2. Draw the background color
    Paint basePaint = Paint()
      ..color = AppColors.thirdColor // Base thirdColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(outerRRect, basePaint);

    // 3. Clip everything else to the card boundaries
    // This ensures decorative shapes don't go outside the rounded corners
    canvas.save();
    canvas.clipRRect(outerRRect);

    // 4. Draw Top-Left Decorative Shape
    // This looks like a large circle centered slightly off-canvas
    Paint decoPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15) // Subtle highlight
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.1),
        size.width * 0.45,
        decoPaint
    );

    // 5. Draw Bottom-Right Decorative Shape
    Paint circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width * 0.95, size.height * 0.75),
        size.width * 0.25,
        circlePaint
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}