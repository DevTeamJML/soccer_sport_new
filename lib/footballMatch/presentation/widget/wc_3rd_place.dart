import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';

// class WC3rdPlace extends StatelessWidget {
//   const WC3rdPlace({super.key});

//   @override
//   Widget build(BuildContext context) {
//      List<FootballMatch>? liveMatches;
//   String matchHome = 'TBD';
//   String matchAway = 'TBD';
//   String matchHomeGoal = '0';
//   String matchAwayGoal = '0';
//   String matchDate = 'TBD';
//   String matchTime = 'TBD';
//   FootballMatch? thirdMatch;
//   FootballMatch? matchOrNull;
//   List<FootballMatch>? match;
//     return Container();
//   }
// }

class WC3rdPlace extends StatefulWidget {
  final List<FootballMatch>? liveMatches;
  final List<FootballMatch>? matches;

  WC3rdPlace({
    this.liveMatches,
    this.matches,
  });

  @override
  State<WC3rdPlace> createState() => _WC3rdPlaceState();
}

class _WC3rdPlaceState extends State<WC3rdPlace> {
  List<FootballMatch>? liveMatches;
  String matchHome = 'TBD';
  String matchAway = 'TBD';
  String matchHomeGoal = '0';
  String matchAwayGoal = '0';
  String matchDate = 'TBD';
  String matchTime = 'TBD';
  FootballMatch? thirdMatch;
  FootballMatch? matchOrNull;
  List<FootballMatch>? match;
  String matchStatus = 'NS';

  @override
  void initState() {
    liveMatches = widget.liveMatches;
    match = widget.matches;

    matchOrNull = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.first
        : null;

    thirdMatch = match != null &&
            matchOrNull != null &&
            match!.first.fixture.id == matchOrNull!.fixture.id
        ? match!.first
        : matchOrNull;
    matchStatus = thirdMatch!.fixture.status.short != null
        ? thirdMatch!.fixture.status.short!
        : 'NS';
    // thirdMatch = match != null ? match!.first : null;

    if (thirdMatch != null) {
      //name
      matchHome = thirdMatch!.home.name;
      matchAway = thirdMatch!.away.name;
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
      if (thirdMatch!.goal != null) {
        if (thirdMatch!.goal!.home != null) {
          matchHomeGoal = thirdMatch!.goal!.home.toString();
        }
        if (thirdMatch!.goal!.away != null) {
          matchAwayGoal = thirdMatch!.goal!.away.toString();
        }
      }
    }

    matchDate = thirdMatch != null
        ? Constant.formattedDateMonth(
            (DateTime.parse(thirdMatch!.fixture.date).toLocal()),
          )
        : matchDate;
    matchTime = thirdMatch != null
        ? Constant.formattedHMTime(
            (DateTime.parse(thirdMatch!.fixture.date).toLocal()),
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
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))),
              )),
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
                                      if (thirdMatch != null)
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Image.network(
                                              thirdMatch!.home.logoUrl,
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
                                      if (thirdMatch != null)
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Image.network(
                                              thirdMatch!.away.logoUrl,
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
