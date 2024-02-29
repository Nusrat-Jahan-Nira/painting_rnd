
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:painting_rnd/utils/color_picker_button.dart';
import 'package:painting_rnd/provider/drawing_data.dart';
import 'package:painting_rnd/utils/drawing_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class DrawingPage extends StatefulWidget {

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {

  final GlobalKey _globalKey = GlobalKey();

  Future<void> _getImageData(RenderRepaintBoundary boundary) async {
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    saveImageToDevice(pngBytes);

    if (pngBytes == null) {
      debugPrint('get Image');
      return;
    }

    if (mounted) {
      showDialog<void>(
        context: context,
        builder: (BuildContext c) {
          return Material(
            color: Colors.blue,
            child: InkWell(
                onTap: () => Navigator.pop(c), child: Column(
              children: [
                const Text('Image Saved!'),
                Image.memory(pngBytes),
              ],
            )),
          );
        },
      );
    }
  }

  Future<void> saveImageToDevice(Uint8List imageData) async {
    try {
      // Get the directory where the app can store files
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/image.png';

      // Write the image data to a file
      File file = File(filePath);
      await file.writeAsBytes(imageData);

      // Show a success message
      print('Image saved to device successfully: $filePath');
    } catch (e) {
      // Show an error message
      print('Error saving image to device: $e');
    }
  }

  void revertToPreviousColor(BuildContext context) {
    Provider.of<DrawingData>(context, listen: false).revertToPreviousColor();
  }

  void changeColor(BuildContext context, Color color) {
    Provider.of<DrawingData>(context, listen: false).setCurrentColor(color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Sketch App'),
        actions: [
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final Offset localPosition = renderBox.globalToLocal(details.globalPosition);
          Provider.of<DrawingData>(context, listen: false).addPoint(localPosition);
        },
        child: Consumer<DrawingData>(
          builder: (context, drawingData, _) {
            return RepaintBoundary(
              key: _globalKey,
              child: CustomPaint(
                size: Size.infinite,
                painter: DrawingPainter(drawingData.points, color: drawingData.currentColor,strokeWidth: Provider.of<DrawingData>(context).strokeWidth,),
                child: Container(),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
          child: Consumer<DrawingData>(
            builder: (context, drawingData, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.undo),
                  onPressed: () {
                    Provider.of<DrawingData>(context, listen: false).undoAction();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.redo),
                  onPressed: () {
                    // Implement redo functionality
                    Provider.of<DrawingData>(context, listen: false).redoAction();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.change_history_rounded),
                  onPressed: () {
                    Provider.of<DrawingData>(context, listen: false).drawTriangle(
                      Offset(50, 50), // Point 1
                      Offset(150, 200), // Point 2
                      Offset(250, 50), // Point 3
                    );
                  },
                ),

                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    Provider.of<DrawingData>(context, listen: false).clearCanvas();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.brush),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Select Stroke Width'),
                              Slider(
                                value: Provider.of<DrawingData>(context).strokeWidth,
                                min: 1.0,
                                max: 20.0,
                                onChanged: (value) {
                                  Provider.of<DrawingData>(context, listen: false).setStrokeWidth(value);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                ColorPickerButton(changeColor: changeColor,revertToPreviousColor: revertToPreviousColor),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getImageData(_globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary);
        },
        child: const Icon(Icons.file_download),
      ),
    );
  }
}

