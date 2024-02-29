

import 'package:flutter/material.dart';

class DrawingData extends ChangeNotifier {
  List<Offset> points = [];
  List<List<Offset>> undoHistory = [];
  List<List<Offset>> redoHistory = [];
  Color currentColor = Colors.black;
  Color previousColor = Colors.black;
  double strokeWidth = 5.0;

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

  // Function to set the stroke width
  void setStrokeWidth(double width) {
    strokeWidth = width;
    notifyListeners();
  }

}