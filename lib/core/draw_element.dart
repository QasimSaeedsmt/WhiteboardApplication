import 'package:flutter/material.dart';

enum ElementType {
  line,
  text,
  rectangle,
}

class DrawnElement {
  final Offset? point;
  final Offset? endPoint;
  final Color color;
  final double thickness;
  final bool isEndOfLine;
  final ElementType type;
  final String textContent;

  DrawnElement({
    this.point,
    this.endPoint,
    this.color = Colors.black,
    this.thickness = 1.0,
    this.isEndOfLine = false,
    this.type = ElementType.line,
    this.textContent = '',
  });
}
