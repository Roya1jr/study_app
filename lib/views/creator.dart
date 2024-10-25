// import 'package:flutter/material.dart';
// import 'package:card_slider/card_slider.dart';

// class NotesPage extends StatelessWidget {
//   const NotesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List<Color> valuesDataColors = [
//       Colors.purple,
//       Colors.yellow,
//       Colors.green,
//       Colors.red,
//       Colors.grey,
//       Colors.blue,
//     ];

//     List<Widget> valuesWidget = [];
//     for (int i = 0; i < valuesDataColors.length; i++) {
//       valuesWidget.add(Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12.0),
//             color: valuesDataColors[i],
//           ),
//           child: Align(
//             alignment: Alignment.center,
//             child: Text(
//               i.toString(),
//               style: const TextStyle(
//                 fontSize: 28,
//               ),
//             ),
//           )));
//     }

//     return Container(
//         alignment: const Alignment(0, 0),
//         child: CardSlider(
//           cards: valuesWidget,
//           bottomOffset: .0005,
//           cardHeight: 0.75,
//           itemDotOffset: 0.25,
//         ));
//   }
// }
