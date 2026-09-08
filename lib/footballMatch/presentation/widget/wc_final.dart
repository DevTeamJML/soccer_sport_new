import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';

class WCFinals extends StatefulWidget {
  final List<FootballMatch>? liveMatches;
  final List<FootballMatch>? matches;

  WCFinals({
    this.liveMatches,
    this.matches,
  });

  @override
  State<WCFinals> createState() => _WCFinalsState();
}

class _WCFinalsState extends State<WCFinals> {
  List<FootballMatch>? liveMatches;
  String matchHome = 'TBD';
  String matchAway = 'TBD';
  String matchHomeGoal = '0';
  String matchAwayGoal = '0';
  String matchDate = '12/18';
  String matchTime = '23:00';
  FootballMatch? finalMatch;
  FootballMatch? matchOrNull;
  List<FootballMatch>? match;
  String matchStatus = 'NS';

  @override
  void initState() {
    liveMatches = widget.liveMatches;

    matchOrNull = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.first
        : null;

    finalMatch = match != null &&
            matchOrNull != null &&
            match!.first.fixture.id == matchOrNull!.fixture.id
        ? match!.first
        : matchOrNull;
    matchStatus = finalMatch!.fixture.status.short != null
        ? finalMatch!.fixture.status.short!
        : 'NS';
    if (finalMatch != null) {
      //name
      matchHome = finalMatch!.home.name;
      matchAway = finalMatch!.away.name;
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
      if (finalMatch!.goal != null) {
        if (finalMatch!.goal!.home != null) {
          matchHomeGoal = finalMatch!.goal!.home.toString();
        }
        if (finalMatch!.goal!.away != null) {
          matchAwayGoal = finalMatch!.goal!.away.toString();
        }
      }
    }

    matchDate = finalMatch != null
        ? Constant.formattedDateMonth(
            (DateTime.parse(finalMatch!.fixture.date).toLocal()),
          )
        : matchDate;
    matchTime = finalMatch != null
        ? Constant.formattedHMTime(
            (DateTime.parse(finalMatch!.fixture.date).toLocal()),
          )
        : matchTime;
    super.initState();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                ),
              ),
              Expanded(child: Container()),
            ],
          )),
          Expanded(child: Container()),
        ],
      ),
      Column(
        children: [
          Expanded(
            flex: 6,
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
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Row(
                                    children: [
                                      if (finalMatch != null)
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Image.network(
                                              finalMatch!.home.logoUrl,
                                            ),
                                          ),
                                        ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(matchHome,
                                            style:
                                                TextStyle(color: Colors.white),
                                            maxLines: 1),
                                      ),
                                    ],
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(matchHomeGoal,
                                        style: TextStyle(color: Colors.white)),
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
                                      if (finalMatch != null)
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Image.network(
                                              finalMatch!.away.logoUrl,
                                            ),
                                          ),
                                        ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(matchAway,
                                            style:
                                                TextStyle(color: Colors.white),
                                            maxLines: 1),
                                      ),
                                    ],
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(matchAwayGoal,
                                        style: TextStyle(color: Colors.white)),
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
            flex: 6,
            child: Container(),
          ),
        ],
      ),
    ]);
  }
}
