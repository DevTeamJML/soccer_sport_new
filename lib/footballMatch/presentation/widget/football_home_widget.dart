import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_events_text.dart';

import '../../domain/entities/event.dart';

class FootballHomeWidget extends StatelessWidget {
  final Team team;
  final bool gotEvents;
  FootballHomeWidget({required this.team, required this.gotEvents});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (gotEvents)
            Expanded(
              child: Container(),
            ),
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: AutoSizeText(
                      team.name,
                      minFontSize: 8,
                      wrapWords: false,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Image.network(
                    team.logoUrl,
                    width: 36.0,
                  ),
                ],
              )),
          // Row(

          //   children: [
          //     SizedBox(
          //       width: 10,
          //     ),
          //     Expanded(
          //       child: AutoSizeText(
          //         team.name,
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           color: Colors.black,
          //         ),
          //       ),
          //     ),
          //     Image.network(
          //       team.logoUrl,
          //       width: 36.0,
          //     ),
          //   ],
          // )
          // Expanded(child: FootballEventsText(events: homeEvent))
        ],
      ),
    );
  }
}
