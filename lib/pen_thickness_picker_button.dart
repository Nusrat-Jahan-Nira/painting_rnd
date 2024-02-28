// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:painting_rnd/main.dart';
// import 'package:provider/provider.dart';
//
// class PenThicknessPickerButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.border_color), // Icon for pen thickness picker
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: Text('Pick a pen thickness'),
//             content: SingleChildScrollView(
//               child: PenThicknessPicker(
//                 thickness: Provider.of<DrawingData>(context, listen: false).penThickness,
//                 onChanged: (thickness) {
//                   Provider.of<DrawingData>(context, listen: false).setPenThickness(thickness);
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class PenThicknessPicker extends StatelessWidget {
//   final double thickness;
//   final ValueChanged<double> onChanged;
//
//   const PenThicknessPicker({
//     Key? key,
//     required this.thickness,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Slider(
//       value: thickness,
//       min: 1,
//       max: 20,
//       onChanged: onChanged,
//     );
//   }
// }
