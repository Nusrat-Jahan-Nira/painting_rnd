import 'package:flutter/material.dart';
import 'package:painting_rnd/color_picker_button.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class DrawingData extends ChangeNotifier {
  // List<Offset> points = [];
  //
  // void addPoint(Offset point) {
  //   points.add(point);
  //   notifyListeners();
  // }
  // // Undo the last drawing action
  // void undoAction() {
  //   if (points.isNotEmpty) {
  //     points.removeLast();
  //     notifyListeners();
  //   }
  // }
  //
  // void clearCanvas() {
  //   if (points.isNotEmpty) {
  //     points.clear();
  //     notifyListeners();
  //   }
  // }
  List<Offset> points = [];
  List<List<Offset>> undoHistory = [];
  List<List<Offset>> redoHistory = [];
  Color currentColor = Colors.black;
  Color previousColor = Colors.black;
  

  void addPoint(Offset point) {
    points.add(point);
    notifyListeners();
  }

  void undoAction() {
    if (points.isNotEmpty) {
      redoHistory.add(points.toList());
      points.removeLast();
      notifyListeners();
    }
  }

  void redoAction() {
    if (redoHistory.isNotEmpty) {
      points = redoHistory.removeLast();
      notifyListeners();
    }
  }

  void clearCanvas() {
    if (points.isNotEmpty) {
      undoHistory.add(points.toList());
      points.clear();
      notifyListeners();
    }
  }

  void setCurrentColor(Color color) {
    currentColor = color;
    notifyListeners();
  }

  void revertToPreviousColor() {
    currentColor = previousColor; // Revert to the previous color
    notifyListeners();
  }

  void drawTriangle(Offset point1, Offset point2, Offset point3) {
    // Clear canvas before drawing triangle
   // clearCanvas();

    // Draw triangle
    addPoint(point1);
    addPoint(point2);
    addPoint(point3);
    addPoint(point1); // Close the triangle by connecting back to the first point
  }

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrawingData(),
      child: MaterialApp(
        title: 'Flutter Painting App',
        home: DrawingPage(),
      ),
    );
  }
}

class DrawingPage extends StatelessWidget {

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
        title: const Text('Drawing App'),
        actions: [
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
              // Implement clear canvas functionality
            },
          ),
          ColorPickerButton(changeColor: changeColor,revertToPreviousColor: revertToPreviousColor),
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
            return CustomPaint(
              painter: DrawingPainter(drawingData.points, color: drawingData.currentColor),
              child: Container(), // You can add any child widget here
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement download drawing functionality
        },
        child: Icon(Icons.file_download),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;

  DrawingPainter(this.points, {this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//*********************************************using action

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:painting_rnd/pen_thickness_picker_button.dart';
// import 'package:provider/provider.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class DrawingData extends ChangeNotifier {
//   List<DrawingAction> actions = [];
//   Color currentColor = Colors.black;
//   double penThickness = 5.0; // Initial pen thickness
//
//   void addDrawingAction(DrawingAction action) {
//     actions.add(action);
//     notifyListeners();
//   }
//
//   void undoLastAction() {
//     if (actions.isNotEmpty) {
//       actions.removeLast();
//       notifyListeners();
//     }
//   }
//
//   void clearCanvas() {
//     actions.clear();
//     notifyListeners();
//   }
//
//   void setCurrentColor(Color color) {
//     currentColor = color;
//     notifyListeners();
//   }
//
//   void setPenThickness(double thickness) {
//     penThickness = thickness;
//     notifyListeners();
//   }
// }
//
// class DrawingAction {
//   final List<Offset> points;
//   final Paint paint;
//
//   DrawingAction(this.points, this.paint);
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => DrawingData(),
//       child: MaterialApp(
//         title: 'Painting App',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: DrawingPage(),
//       ),
//     );
//   }
// }
//
// class DrawingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Painting App'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.undo),
//             onPressed: () {
//               Provider.of<DrawingData>(context, listen: false).undoLastAction();
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () {
//               Provider.of<DrawingData>(context, listen: false).clearCanvas();
//             },
//           ),
//           ColorPickerButton(),
//           //PenThicknessPickerButton(),
//         ],
//       ),
//       body: Center(
//         child: Consumer<DrawingData>(
//           builder: (context, drawingData, _) {
//             return GestureDetector(
//               onPanStart: (details) {
//                 final RenderBox renderBox = context.findRenderObject() as RenderBox;
//                 final localPosition = renderBox.globalToLocal(details.globalPosition);
//                 drawingData.addDrawingAction(
//                   DrawingAction(
//                     [localPosition],
//                     Paint()
//                       ..color = drawingData.currentColor
//                       ..strokeCap = StrokeCap.round
//                       ..strokeWidth = 2.0,
//                   ),
//                 );
//               },
//               onPanUpdate: (details) {
//                 final RenderBox renderBox = context.findRenderObject() as RenderBox;
//                 final localPosition = renderBox.globalToLocal(details.globalPosition);
//                 drawingData.actions.last.points.add(localPosition);
//                 drawingData.notifyListeners();
//               },
//               child: CustomPaint(
//                 painter: DrawingPainter(drawingData.actions),
//                 size: Size.infinite,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class DrawingPainter extends CustomPainter {
//   final List<DrawingAction> actions;
//
//   DrawingPainter(this.actions);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     for (final action in actions) {
//       final path = Path()..addPolygon(action.points, false);
//       canvas.drawPath(path, action.paint);
//     }
//   }
//
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
//
// class ColorPickerButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.palette),
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: Text('Pick a color'),
//             content: SingleChildScrollView(
//               child: ColorPicker(
//                 pickerColor: Provider.of<DrawingData>(context, listen: false).currentColor,
//                 onColorChanged: (color) {
//                   Provider.of<DrawingData>(context, listen: false).setCurrentColor(color);
//                   //Navigator.pop(context);
//                 },
//                 colorPickerWidth: 300.0,
//                 pickerAreaHeightPercent: 0.7,
//                 enableAlpha: true,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


