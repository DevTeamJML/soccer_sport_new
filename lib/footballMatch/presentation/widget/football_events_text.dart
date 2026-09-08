// import 'dart:math';

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:soccer_sport/footballMatch/domain/entities/event.dart';

// class FootballEventsText extends StatefulWidget {
//   final List<Event>? events;
//   final bool isRight;
//   FootballEventsText({required this.events, required this.isRight});

//   @override
//   State<FootballEventsText> createState() => _FootballEventsTextState();
// }

// class _FootballEventsTextState extends State<FootballEventsText> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   Widget textIcon(Event? event) {
//     if (event != null && event.type != null) {
//       if (event.type!.toLowerCase() == 'goal' ||
//           event.type!.toLowerCase() == 'var') {
//         if (widget.isRight) {
//           return Row(
//             children: [
//               Stack(
//                 children: [
//                   Row(
//                     children: [
//                       if (event.detail.toLowerCase() == "own goal")
//                         Text(
//                           "OG",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 7,
//                               color: Colors.black),
//                         ),
//                       if (event.detail.toLowerCase() == "penalty" ||
//                           event.detail.toLowerCase() == "missed penalty")
//                         Text(
//                           "PEN",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 7,
//                               color: Colors.black),
//                         ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 2,
//                           right: 6,
//                         ),
//                         child: Icon(
//                           FontAwesomeIcons.futbol,
//                           color: Colors.black,
//                           size: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (event.detail.toLowerCase() == "penalty" ||
//                       event.detail.toLowerCase() == "missed penalty" ||
//                       event.detail.toLowerCase() == "goal cancelled" ||
//                       event.detail.toLowerCase() == "penalty confirmed")
//                     Positioned(
//                       right: 1,
//                       bottom: 1,
//                       child: (event.detail.toLowerCase() == "penalty" ||
//                               event.detail.toLowerCase() == "penalty confirmed")
//                           ? Container(
//                               height: 8,
//                               width: 8,
//                               decoration: BoxDecoration(
//                                 color: Colors.black,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Icon(
//                                   CupertinoIcons.check_mark_circled_solid,
//                                   color: Colors.green,
//                                   size: 8),
//                             )
//                           : Container(
//                               height: 8,
//                               width: 8,
//                               decoration: BoxDecoration(
//                                 color: Colors.black,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Icon(CupertinoIcons.clear_circled_solid,
//                                   color: Colors.red, size: 8),
//                             ),
//                     )
//                 ],
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               Expanded(
//                 child: AutoSizeText(
//                   event.time.elapsed.toString() +
//                       " -" +
//                       (event.player != null && event.player!.name != null
//                           ? event.player!.name!
//                           : event.detail),
//                   style: TextStyle(color: Colors.grey),
//                   minFontSize: 6,
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return Row(
//             children: [
//               Expanded(
//                 child: AutoSizeText(
//                   (event.player != null && event.player!.name != null
//                           ? event.player!.name!
//                           : event.detail) +
//                       "- " +
//                       event.time.elapsed.toString(),
//                   style: TextStyle(color: Colors.grey),
//                   textAlign: TextAlign.end,
//                   minFontSize: 6,
//                 ),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               Stack(
//                 children: [
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           right: 2,
//                           left: 6,
//                         ),
//                         child: Icon(
//                           FontAwesomeIcons.futbol,
//                           color: Colors.black,
//                           size: 12,
//                         ),
//                       ),
//                       if (event.detail.toLowerCase() == "own goal")
//                         Text(
//                           "OG",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 7,
//                               color: Colors.black),
//                         ),
//                       if (event.detail.toLowerCase() == "penalty" ||
//                           event.detail.toLowerCase() == "missed penalty")
//                         Text(
//                           "PEN",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 7,
//                               color: Colors.black),
//                         ),
//                     ],
//                   ),
//                   if (event.detail.toLowerCase() == "penalty" ||
//                       event.detail.toLowerCase() == "missed penalty" ||
//                       event.detail.toLowerCase() == "goal cancelled" ||
//                       event.detail.toLowerCase() == "penalty confirmed")
//                     Positioned(
//                       left: 1,
//                       bottom: 1,
//                       child: (event.detail.toLowerCase() == "penalty" ||
//                               event.detail.toLowerCase() == "penalty confirmed")
//                           ? Container(
//                               height: 8,
//                               width: 8,
//                               decoration: BoxDecoration(
//                                 color: Colors.black,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Icon(
//                                   CupertinoIcons.check_mark_circled_solid,
//                                   color: Colors.green,
//                                   size: 8),
//                             )
//                           : Container(
//                               height: 8,
//                               width: 8,
//                               decoration: BoxDecoration(
//                                 color: Colors.black,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Icon(CupertinoIcons.clear_circled_solid,
//                                   color: Colors.red, size: 8),
//                             ),
//                     ),
//                 ],
//               ),
//             ],
//           );
//         }
//       } else if (event.type.toLowerCase() == 'card') {
//         if (widget.isRight) {
//           return Row(
//             children: [
//               FittedBox(
//                 fit: BoxFit.fill,
//                 child: Icon(
//                   Icons.rectangle,
//                   color: event.detail.toLowerCase().contains('yellow')
//                       ? Colors.yellow
//                       : Colors.red,
//                 ),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               Expanded(
//                 child: AutoSizeText(
//                   event.time.elapsed.toString() +
//                       " -" +
//                       (event.player != null && event.player!.name != null
//                           ? event.player!.name!
//                           : ''),
//                   style: TextStyle(color: Colors.grey),
//                   minFontSize: 6,
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return Row(
//             children: [
//               Expanded(
//                 child: AutoSizeText(
//                   (event.player != null && event.player!.name != null
//                           ? event.player!.name!
//                           : '') +
//                       "- " +
//                       event.time.elapsed.toString(),
//                   style: TextStyle(color: Colors.grey),
//                   textAlign: TextAlign.end,
//                   minFontSize: 6,
//                 ),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               FittedBox(
//                 fit: BoxFit.fill,
//                 child: Icon(
//                   Icons.rectangle,
//                   color: event.detail.toLowerCase().contains('yellow')
//                       ? Colors.yellow
//                       : Colors.red,
//                 ),
//               ),
//             ],
//           );
//         }
//       } else if (event.type.toLowerCase() == 'subst') {
//         if (widget.isRight) {
//           return Row(
//             children: [
//               FittedBox(
//                 fit: BoxFit.fill,
//                 child: Icon(
//                   Icons.group,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               Expanded(
//                 child: AutoSizeText(
//                   event.time.elapsed.toString() + " -" + event.detail,
//                   style: TextStyle(color: Colors.grey),
//                   minFontSize: 6,
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return Row(
//             children: [
//               Expanded(
//                 child: AutoSizeText(
//                   event.detail + "- " + event.time.elapsed.toString(),
//                   style: TextStyle(color: Colors.grey),
//                   textAlign: TextAlign.end,
//                   minFontSize: 6,
//                 ),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               FittedBox(
//                 fit: BoxFit.fill,
//                 child: Icon(
//                   Icons.group,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           );
//         }
//       } else {
//         if (widget.isRight) {
//           return Row(
//             children: [
//               FittedBox(
//                 fit: BoxFit.fill,
//                 child: Icon(
//                   Icons.info,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               Expanded(
//                 child: AutoSizeText(
//                   event.time.elapsed.toString() + " -" + event.detail,
//                   style: TextStyle(color: Colors.grey),
//                   minFontSize: 6,
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Expanded(
//                 child: AutoSizeText(
//                   event.detail + "- " + event.time.elapsed.toString(),
//                   style: TextStyle(color: Colors.grey),
//                   textAlign: TextAlign.end,
//                   minFontSize: 6,
//                 ),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               FittedBox(
//                 fit: BoxFit.fill,
//                 child: Icon(
//                   Icons.info,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           );
//         }
//       }
//     } else {
//       return Container();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.events != null && widget.events!.length > 0) {
//       Event lastEvent = widget.events!.last;
//       Event? last2ndEvent = widget.events!.length != 1
//           ? widget.events![widget.events!.length - 2]
//           : null;
//       return Padding(
//         padding: EdgeInsets.only(bottom: 5, top: 2),
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Expanded(flex: 1, child: textIcon(lastEvent)),
//               Expanded(flex: 1, child: textIcon(last2ndEvent)),
//             ]),
//       );
//     } else {
//       return Container();
//     }
//   }
// }
