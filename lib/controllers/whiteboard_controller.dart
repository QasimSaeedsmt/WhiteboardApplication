import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/draw_element.dart';
import '../core/draw_line.dart';

class WhiteboardController extends GetxController {
  var lines = <DrawnLine>[].obs;
  Offset? lastKnownPosition;

  var redoLines = <DrawnLine>[].obs;
  var currentColor = Colors.black.obs;
  var currentThickness = 1.0.obs;
  var isErasing = false.obs;

  void addLine(DrawnLine line) {
    lines.add(line);
    lastKnownPosition = line.point;
    if (redoLines.isNotEmpty) {
      redoLines.clear();
    }
  }

// Add in WhiteboardController
  void addAnnotationOrShape(DrawnElement element) {
    lines.add(element as DrawnLine);
  }

  void undo() {
    if (lines.isNotEmpty) {
      redoLines.add(lines.last);
      lines.removeLast();
    }
  }

  void redo() {
    if (redoLines.isNotEmpty) {
      lines.add(redoLines.last);
      redoLines.removeLast();
    }
  }

  void clearAll() {
    lines.clear();
    redoLines.clear();
  }

  void setThickness(double value) {
    currentThickness.value = value;
  }
}
