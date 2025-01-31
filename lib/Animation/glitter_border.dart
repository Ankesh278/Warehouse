// CustomPainter to animate the light/glitter effect along the button border
import 'dart:ui';

import 'package:flutter/material.dart';

class GlitterBorderPainter extends CustomPainter {
  final double progress;
  GlitterBorderPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    // Static border paint
    final Paint borderPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    // Draw the rectangular border
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      borderPaint,
    );

    // Glittering light paint
    final Paint lightPaint = Paint()
      ..color = Colors.amber.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    // Compute the length of the entire border (perimeter of the rectangle)
    final double totalPerimeter = 2 * (size.width + size.height);

    // Calculate the current position of the glitter based on the progress
    final double glitterPosition = progress * totalPerimeter;

    // Compute the position of the glitter light along the border
    Offset glitterOffset;
    if (glitterPosition <= size.width) {
      // Top edge
      glitterOffset = Offset(glitterPosition, 0);
    } else if (glitterPosition <= size.width + size.height) {
      // Right edge
      glitterOffset = Offset(size.width, glitterPosition - size.width);
    } else if (glitterPosition <= 2 * size.width + size.height) {
      // Bottom edge
      glitterOffset = Offset(2 * size.width + size.height - glitterPosition, size.height);
    } else {
      // Left edge
      glitterOffset = Offset(0, totalPerimeter - glitterPosition);
    }
    canvas.drawCircle(glitterOffset, 5, lightPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}