import 'package:flutter/material.dart';

class Annotation {
  final Offset? point;
  final Offset? endPoint; // For shapes
  final Color color;
  final double thickness;
  final bool isEndOfLine;
  final String textContent; // For text
  final AnnotationType type;

  Annotation(
      {this.point,
      this.endPoint,
      this.color = Colors.black,
      this.thickness = 1.0,
      this.isEndOfLine = false,
      this.textContent = '',
      this.type = AnnotationType.line});
}

enum AnnotationType { line, text, rectangle, circle }
