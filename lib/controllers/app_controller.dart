import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:whiteboard/controllers/whiteboard_controller.dart';

class AppController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var whiteboards = <WhiteboardController>[WhiteboardController()].obs;
  var currentWhiteboardIndex = 0.obs;

  void switchWhiteboard(int index) {
    if (index >= 0 && index < whiteboards.length) {
      currentWhiteboardIndex.value = index;
    }
  }

  void addWhiteboard() {
    final newWhiteboard = WhiteboardController();
    whiteboards.add(newWhiteboard);
    _firestore.collection('whiteboards').add({
      'data': newWhiteboard.lines.map((line) => line.toMap()).toList(),
      'color': newWhiteboard.currentColor.value.toString(),
      'thickness': newWhiteboard.currentThickness.value,
    });
    currentWhiteboardIndex.value = whiteboards.length - 1;
  }

  void removeCurrentWhiteboard() {
    if (whiteboards.length > 1) {
      _firestore
          .collection('whiteboards')
          .doc(currentWhiteboardIndex.value.toString())
          .delete();

      whiteboards.removeAt(currentWhiteboardIndex.value);
      currentWhiteboardIndex.value = max(0, currentWhiteboardIndex.value - 1);
    }
  }

  WhiteboardController get currentWhiteboard =>
      whiteboards[currentWhiteboardIndex.value];
}
