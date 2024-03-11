import 'package:flutter/material.dart';

class DrawnLine {
  final Offset? point;
  final Color color;
  final double thickness;
  final bool isEndOfLine;

  Map<String, dynamic> toMap() {
    return {
      'point': point != null ? {'x': point!.dx, 'y': point!.dy} : null,
      'color': color.value,
      'thickness': thickness,
      'isEndOfLine': isEndOfLine,
    };
  }

  DrawnLine.fromMap(Map<String, dynamic> map)
      : point = map['point'] != null
            ? Offset(map['point']['x'], map['point']['y'])
            : null,
        color = Color(map['color']),
        thickness = map['thickness'].toDouble(),
        isEndOfLine = map['isEndOfLine'];

  DrawnLine(
      {this.point,
      this.color = Colors.black,
      this.thickness = 1.0,
      this.isEndOfLine = false});
}
