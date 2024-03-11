import 'package:flutter/material.dart';

import '../../core/draw_line.dart';

class WhiteboardPainter extends CustomPainter {
  final List<DrawnLine> lines;

  WhiteboardPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    for (int i = 0; i < lines.length - 1; i++) {
      if (lines[i].point != null &&
          lines[i + 1].point != null &&
          !lines[i + 1].isEndOfLine) {
        paint.color = lines[i].color;
        paint.strokeWidth = lines[i].thickness;
        paint.strokeCap = StrokeCap.round;
        canvas.drawLine(lines[i].point!, lines[i + 1].point!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
