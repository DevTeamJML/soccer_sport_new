import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';

import '../../domain/entities/football_match.dart';

class WcQuarterContent extends StatelessWidget {
  final FootballMatch? match;
  final String? date;
  final String? time;
  final bool downward;
  const WcQuarterContent(
      {this.match, this.date, this.time, required this.downward});

  @override
  Widget build(BuildContext context) {
    String matchHome = 'TBD';
    String matchAway = 'TBD';
    String matchHomeGoal = '0';
    String matchAwayGoal = '0';
    String matchDate = '';
    String matchTime = '';
    String matchStatus = 'NS';

    if (match != null) {
      //name
      matchHome = match!.home.name;
      matchAway = match!.away.name;
      matchStatus = match!.fixture.status.short != null
          ? match!.fixture.status.short!
          : 'NS';
      // if(match!.home.name.split(' ').length >1){

      // }else{=  match!.home.name;
      //   // if(match!.home.name.length > 10){
      //   //   matchHome =match!.home.;
      //   // }else{
      //   //
      //   // }
      // }
      // if(match!.away.name.split(' ').length >1){

      // }else{

      // }
      //goal
      if (match!.goal != null) {
        if (match!.goal!.away != null) {
          matchHomeGoal = match!.goal!.home.toString();
        }
        if (match!.goal!.home != null) {
          matchAwayGoal = match!.goal!.away.toString();
        }
      }
    }

    matchDate = match != null
        ? Constant.formattedDateMonth(
            (DateTime.parse(match!.fixture.date).toLocal()),
          )
        : date!;
    matchTime = match != null
        ? Constant.formattedHMTime(
            (DateTime.parse(match!.fixture.date).toLocal()),
          )
        : time!;
    return Expanded(
      child: Container(
        child: Stack(children: [
          Row(
            children: [
              Expanded(
                  child: Column(children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Colors.grey),
                    )),
                  ),
                ),
                Expanded(child: Container()),
              ])),
              Expanded(
                  child: Column(children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                          color: !downward
                              ? Colors.grey
                              : Constant.backgroundColor),
                    ),
                  ),
                )),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(color: Colors.grey),
                      right: BorderSide(
                          color: downward
                              ? Colors.grey
                              : Constant.backgroundColor),
                    )),
                  ),
                ),
              ]))
            ],
          ),
          Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Expanded(
                flex: 2,
                child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: matchStatus != 'NS'
                          ? Constant.backgroundColor
                          : Constant.color1,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      // border: Border()
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(
                            0.0,
                            0.0,
                          ),
                          blurRadius: 0.5,
                          spreadRadius: 0.5,
                        ), //
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AutoSizeText(matchDate,
                                style: TextStyle(color: Colors.white)),
                            AutoSizeText(matchTime,
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Row(
                                        children: [
                                          if (match != null)
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: Image.network(
                                                  match!.home.logoUrl,
                                                ),
                                              ),
                                            ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(matchHome,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                maxLines: 1),
                                          ),
                                        ],
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Text(matchHomeGoal,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Row(
                                        children: [
                                          if (match != null)
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: Image.network(
                                                  match!.away.logoUrl,
                                                ),
                                              ),
                                            ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(matchAway,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                maxLines: 1),
                                          ),
                                        ],
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Text(matchAwayGoal,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
