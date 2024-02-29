
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:painting_rnd/main.dart';
import 'package:provider/provider.dart';

class ColorPickerButton extends StatelessWidget {
  final void Function(BuildContext, Color) changeColor;
  final void Function(BuildContext) revertToPreviousColor;

  ColorPickerButton({required this.changeColor, required this.revertToPreviousColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.color_lens),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Pick a color"),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: Colors.black,
                  onColorChanged: (color) {
                    Navigator.of(context).pop();
                    changeColor(context, color);
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    revertToPreviousColor(context);
                  },
                  child: Text('Revert to Previous Color'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// class ColorPickerButton extends StatelessWidget {
//   final void Function(BuildContext, Color) changeColor;
//
//   ColorPickerButton({required this.changeColor});
//
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.color_lens),
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("Pick a color"),
//               content: SingleChildScrollView(
//                 child: BlockPicker(
//                   pickerColor: Colors.black,
//                   onColorChanged: (color) {
//                     Navigator.of(context).pop();
//                     changeColor(context, color);
//                   },
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }


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