import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/app_controller.dart';
import '../../../core/draw_element.dart';
import '../../../core/draw_line.dart';
import '../../painters/rectangular_preview_painter.dart';
import '../../painters/whiteboard_painter.dart';

class WhiteboardPage extends StatelessWidget {
  final AppController appController = Get.put(AppController());

  WhiteboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whiteboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_outlined),
            onPressed: appController.addWhiteboard,
            tooltip: 'Add Whiteboard',
          ),
          Obx(() => DropdownButton<int>(
                value: appController.currentWhiteboardIndex.value,
                items: List.generate(appController.whiteboards.length, (index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text("Whiteboard ${index + 1}"),
                  );
                }),
                onChanged: (int? newIndex) {
                  if (newIndex != null) {
                    appController.switchWhiteboard(newIndex);
                  }
                },
              )),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              if (appController.whiteboards.length > 1) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete"),
                      content: const Text(
                          "Are you sure you want to delete the current whiteboard?"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        ElevatedButton(
                            onPressed: () {
                              appController.removeCurrentWhiteboard();
                              Navigator.pop(context);
                            },
                            child: const Text("Clear")),
                      ],
                    );
                  },
                );
              }
            },
            tooltip: 'Remove Current Whiteboard',
          ),
          const SizedBox(
            width: 15,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Clear"),
                    content: const Text(
                        "Are you sure to clear the current whiteboard?"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            appController.currentWhiteboard.clearAll();
                            Navigator.pop(context);
                          },
                          child: const Text("Yes")),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Obx(() => GestureDetector(
            onPanUpdate: (details) {
              Offset position = details.localPosition;
              if (details.delta.dy.abs() > 1 || details.delta.dx.abs() > 1) {
                appController.currentWhiteboard.addLine(DrawnLine(
                    point: position,
                    color: appController.currentWhiteboard.currentColor.value,
                    thickness: appController
                        .currentWhiteboard.currentThickness.value));
              }
            },
            onPanEnd: (details) {
              appController.currentWhiteboard
                  .addLine(DrawnLine(isEndOfLine: true));
            },
            child: CustomPaint(
              painter: WhiteboardPainter(
                  appController.currentWhiteboard.lines.toList()),
              child: Container(),
            ),
          )),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(
              () => IconButton(
                icon: const Icon(Icons.undo),
                onPressed: appController.currentWhiteboard.undo,
              ),
            ),
            Obx(
              () => IconButton(
                icon: const Icon(Icons.redo),
                onPressed: appController.currentWhiteboard.redo,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: () async {
                String? textValue = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    String tempText = "";
                    return AlertDialog(
                      title: Text("Enter Annotation Text"),
                      content: TextField(
                        onChanged: (value) {
                          tempText = value;
                        },
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text("Add"),
                          onPressed: () {
                            Navigator.pop(context, tempText);
                          },
                        ),
                      ],
                    );
                  },
                );
                if (textValue != null && textValue.trim().isNotEmpty) {
                  appController.currentWhiteboard
                      .addAnnotationOrShape(DrawnElement(
                    point: appController.currentWhiteboard.lastKnownPosition,
                    // Capture current touch point
                    textContent: textValue,
                    type: ElementType.text,
                    color: appController.currentWhiteboard.currentColor.value,
                    thickness:
                        appController.currentWhiteboard.currentThickness.value,
                  ));
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.crop_square),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final points = <Offset?>[null, null];
                    bool isDrawing = false;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Draw Rectangle'),
                          content: GestureDetector(
                            onPanDown: (details) {
                              if (!isDrawing) {
                                setState(() {
                                  isDrawing = true;
                                  points[0] = details.localPosition;
                                });
                              }
                            },
                            onPanUpdate: (details) {
                              if (isDrawing) {
                                setState(() {
                                  points[1] = details.localPosition;
                                });
                              }
                            },
                            onPanEnd: (details) {
                              if (isDrawing) {
                                setState(() {
                                  isDrawing = false;
                                  final startPoint = points[0];
                                  final endPoint = points[1];
                                  if (startPoint != null && endPoint != null) {
                                    appController.currentWhiteboard
                                        .addAnnotationOrShape(
                                      DrawnElement(
                                        point: startPoint,
                                        endPoint: endPoint,
                                        type: ElementType.rectangle,
                                        color: appController.currentWhiteboard
                                            .currentColor.value,
                                        thickness: appController
                                            .currentWhiteboard
                                            .currentThickness
                                            .value,
                                      ),
                                    );
                                  }
                                  points[0] = null;
                                  points[1] = null;
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: CustomPaint(
                              painter: RectanglePreviewPainter(points),
                              child: Container(),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            Obx(() => DropdownButton<Color>(
                  value: appController.currentWhiteboard.currentColor.value,
                  items: <Color>[
                    Colors.black,
                    Colors.red,
                    Colors.green,
                    Colors.blue,
                    Colors.teal,
                    Colors.brown,
                    Colors.purple
                  ].map((Color color) {
                    return DropdownMenuItem<Color>(
                      value: color,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: color),
                        width: 20,
                        height: 20,
                      ),
                    );
                  }).toList(),
                  onChanged: (Color? newValue) {
                    if (newValue != null) {
                      appController.currentWhiteboard.currentColor.value =
                          newValue;
                    }
                  },
                )),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Adjust Brush Thickness'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() => Slider(
                                thumbColor: Colors.black,
                                activeColor: Colors.blue,
                                value: appController
                                    .currentWhiteboard.currentThickness.value,
                                min: 1.0,
                                max: 20.0,
                                onChanged: (double newValue) {
                                  appController.currentWhiteboard
                                      .setThickness(newValue);
                                },
                              )),
                          Obx(() => Text(
                              'Thickness: ${appController.currentWhiteboard.currentThickness.value.toStringAsFixed(2)}')),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        )
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.line_weight),
              tooltip: 'Adjust Brush Thickness',
            )
          ],
        ),
      ),
    );
  }
}
