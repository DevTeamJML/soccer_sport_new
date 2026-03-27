// import 'dart:math';
// import 'package:flutter/material.dart';

// class SlotMachine extends StatefulWidget {
//   final Function onPrizeSelected;

//   SlotMachine({this.onPrizeSelected});

//   @override
//   _SlotMachineState createState() => _SlotMachineState();
// }

// class _SlotMachineState extends State<SlotMachine>
//     with SingleTickerProviderStateMixin {
//   AnimationController _animationController;
//   double _angle = 0;
//   final _prizes = [
//     'Prize 1',
//     'Prize 2',
//     'Prize 3',
//     'Prize 4',
//     'Prize 5',
//     'Prize 6',
//     'Prize 7',
//     'Prize 8',
//     'Prize 9',
//     'Prize 10',
//   ];

//   @override
//   void initState() {
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 5),
//       vsync: this,
//     )..addListener(() {
//         setState(() {
//           _angle = _animationController.value * 2 * pi;
//         });
//       });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200,
//       height: 200,
//       child: Stack(
//         children: [
//           for (int i = 0; i < _prizes.length; i++)
//             Transform.rotate(
//               angle: i * 2 * pi / _prizes.length + _angle,
//               child: Container(
//                 alignment: Alignment.center,
//                 width: 150,
//                 height: 150,
//                 decoration: BoxDecoration(
//                   color: i % 2 == 0 ? Colors.yellow : Colors.red,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   _prizes[i],
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           Positioned(
//             top: 60,
//             left: 60,
//             child: SizedBox(
//               width: 80,
//               height: 80,
//               child: ElevatedButton(
//                 onPressed: _startSpin,
//                 child: Text('Spin'),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _startSpin() {
//     _animationController.reset();
//     _animationController.forward().whenComplete(() {
//       widget.onPrizeSelected(_prizes[_calculateSelectedPrizeIndex()]);
//     });
//   }

//   int _calculateSelectedPrizeIndex() {
//     final random = Random();
//     return random.nextInt(_prizes.length);
//   }
// }
