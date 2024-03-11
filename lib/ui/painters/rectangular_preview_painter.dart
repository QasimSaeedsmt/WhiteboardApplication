import 'package:flutter/material.dart';

class RectanglePreviewPainter extends CustomPainter {
  final List<Offset?> points;

  RectanglePreviewPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    if (points[0] != null && points[1] != null) {
      final startPoint = points[0]!;
      final endPoint = points[1]!;
      canvas.drawRect(
        Rect.fromPoints(startPoint, endPoint),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
