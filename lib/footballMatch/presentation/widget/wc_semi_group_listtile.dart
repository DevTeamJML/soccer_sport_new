import 'package:flutter/material.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/wc_quarter_content.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/wc_semi_content.dart';

class WCSemiGroupListtile extends StatelessWidget {
  final FootballMatch? first;
  final FootballMatch? second;
  final String firstDate;
  final String firstTime;

  final String secondDate;
  final String secondTime;
  WCSemiGroupListtile({
    this.first,
    this.second,
    required this.firstDate,
    required this.firstTime,
    required this.secondDate,
    required this.secondTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WcSemiContent(
          match: first != null ? first : null,
          date: firstDate,
          time: firstTime,
          downward: true,
        ),
        WcSemiContent(
          match: second != null ? second : null,
          date: secondDate,
          time: secondTime,
          downward: false,
        ),
      ],
    );
    // return Column(
    //   children: [
    //     Expanded(
    //       child: Container(
    //         child: Stack(children: [
    //           Row(
    //             children: [
    //               Expanded(
    //                   child: Column(children: [
    //                 Expanded(
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                         border: Border(
    //                       bottom: BorderSide(color: Colors.grey),
    //                     )),
    //                   ),
    //                 ),
    //                 Expanded(child: Container()),
    //               ])),
    //               Expanded(
    //                   child: Column(children: [
    //                 Expanded(child: Container()),
    //                 Expanded(
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                         border: Border(
    //                       top: BorderSide(color: Colors.grey),
    //                       right: BorderSide(color: Colors.grey),
    //                     )),
    //                   ),
    //                 ),
    //               ]))
    //             ],
    //           ),
    //           Column(
    //             children: [
    //               Expanded(
    //                 flex: 3,
    //                 child: Container(),
    //               ),
    //               Expanded(
    //                   flex: 2,
    //                   child: Container(
    //                       margin: EdgeInsets.all(10), color: Colors.blue)),
    //               Expanded(
    //                 flex: 3,
    //                 child: Container(),
    //               ),
    //             ],
    //           ),
    //         ]),
    //       ),
    //     ),
    //     Expanded(
    //       child: Container(
    //         child: Stack(children: [
    //           Row(
    //             children: [
    //               Expanded(
    //                   child: Column(children: [
    //                 Expanded(
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                         border: Border(
    //                       bottom: BorderSide(color: Colors.grey),
    //                     )),
    //                   ),
    //                 ),
    //                 Expanded(child: Container()),
    //               ])),
    //               Expanded(
    //                   child: Column(children: [
    //                 Expanded(
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                         border: Border(
    //                       bottom: BorderSide(color: Colors.grey),
    //                       right: BorderSide(color: Colors.grey),
    //                     )),
    //                   ),
    //                 ),
    //                 Expanded(child: Container()),
    //               ]))
    //             ],
    //           ),
    //           Column(
    //             children: [
    //               Expanded(
    //                 flex: 3,
    //                 child: Container(),
    //               ),
    //               Expanded(
    //                   flex: 2,
    //                   child: Container(
    //                       margin: EdgeInsets.all(10), color: Colors.red)),
    //               Expanded(
    //                 flex: 3,
    //                 child: Container(),
    //               ),
    //             ],
    //           ),
    //         ]),
    //       ),
    //     ),
    //   ],
    // );
  }
}
