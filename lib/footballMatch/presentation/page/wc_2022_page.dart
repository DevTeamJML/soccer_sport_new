import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/error_widget.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/wc_3rd_place.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/wc_8th.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/wc_final.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/wc_quarter.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/wc_semi.dart';
import 'dart:convert';

import 'package:soccer_sport/injection_container.dart';

class WC2022Page extends StatefulWidget {
  @override
  State<WC2022Page> createState() => _WC2022PageState();
}

class _WC2022PageState extends State<WC2022Page> {
  late DatabaseReference database;
  late DatabaseReference wc2022;

  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();
  List<FootballMatch> liveMatches = [];
  List<FootballMatch> eightFinals = [];
  List<FootballMatch> quarterFinals = [];
  List<FootballMatch> semiFinals = [];
  List<FootballMatch> thirdPlace = [];

  List<FootballMatch> finals = [];
  List<FootballMatch> match = [];
  List<String> wc2022Round = [];
  @override
  void initState() {
    // TODO: implement initState
    database = FirebaseDatabase.instance.ref('62');
    wc2022 = FirebaseDatabase.instance.ref('wc2022');

    wc2022.onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          // print(event.snapshot.value);
          wc2022Round = List<String>.from(event.snapshot.value as List);
        });
      }
    });
    _footballMatchBloc
        .add(GetAllMatchByLeagueRequest(leagueId: '1', season: '2022'));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _footballMatchBloc.close();
    database.onValue.drain();
    super.dispose();
  }

  bool isWordcupLeague(FootballMatch match) {
    return match.league != null && match.league!.id == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FIFA World Cup 2022(tm)'),
      ),
      body: InteractiveViewer(
        constrained: false,
        child: BlocProvider(
          create: (context) => _footballMatchBloc,
          child: BlocListener<FootballMatchBloc, FootballMatchState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is AllMatchByLeagueGet) {
                if (state.footballMatches.length > 0) {
                  setState(() {
                    eightFinals = state.footballMatches
                        .where((element) => (element.league!.round != null &&
                            (element.league!.round!.toLowerCase() ==
                                wc2022Round[0])))
                        .toList();
                    quarterFinals = state.footballMatches.where((element) {
                      return (element.league!.round != null &&
                          element.league!.round!.toLowerCase() ==
                              wc2022Round[1]);
                    }).toList();

                    semiFinals = state.footballMatches
                        .where((element) => (element.league!.round != null &&
                            element.league!.round!.toLowerCase() ==
                                wc2022Round[2]))
                        .toList();
                    thirdPlace = state.footballMatches
                        .where((element) => (element.league!.round != null &&
                            element.league!.round!.toLowerCase() ==
                                wc2022Round[3]))
                        .toList();
                    finals = state.footballMatches
                        .where((element) => (element.league!.round != null &&
                            element.league!.round!.toLowerCase() ==
                                wc2022Round[4]))
                        .toList();
                  });
                  print(state.footballMatches.last.league!.round);
                }
              }
            },
            child: BlocBuilder<FootballMatchBloc, FootballMatchState>(
              builder: (context, state) {
                if (state is GettingAllMatchByLeague) {
                  return LoadingWidget();
                } else if (state is FootballMatchesError) {
                  return ErrorsWidget();
                } else {
                  return StreamBuilder(
                      stream: database.onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingWidget();
                        } else if (snapshot.hasData) {
                          DatabaseEvent data = snapshot.data as DatabaseEvent;
                          if (data.snapshot.value != null) {
                            var jsonvalue = Map<String, dynamic>.from(
                                data.snapshot.value as LinkedHashMap);
                            // print(jsonvalue);
                            if (jsonvalue.isNotEmpty) {
                              wc2022Round = wc2022Round;
                              print('testing');
                              List<FootballMatch> lives = jsonvalue.entries
                                  .map((entry) {
                                    FootballMatch match =
                                        FootballMatchModel.fromJson(jsonDecode(
                                            jsonEncode(entry.value)));
                                    if (match.league!.id == 1) {
                                      return match;
                                    } else {
                                      return null;
                                    }
                                  })
                                  .whereNotNull()
                                  .toList();
                              // if (match.length > 0 && (lives.length == 0)){

                              // }

                              if (lives.length > 0) {
                                match = lives;
                              }
                              //   eightFinals = liveMatches
                              //       .firstWhereOrNull((element) =>
                              //           (element.round != null &&
                              //               element.round!.toLowerCase() ==
                              //                   '8th finals' &&
                              //               isWordcupLeague(element)))
                              //       .toList();
                              // quarterFinals = liveMatches
                              //     .where((element) => (element.round != null &&
                              //         element.round!.toLowerCase() ==
                              //             'quarter-finals' &&
                              //         isWordcupLeague(element)))
                              //     .toList();
                              // semiFinals = liveMatches
                              //     .where((element) => (element.round != null &&
                              //         element.round!.toLowerCase() ==
                              //             'semi-finals' &&
                              //         isWordcupLeague(element)))
                              //     .toList();
                              // thirdPlace = liveMatches
                              //     .where((element) => (element.round != null &&
                              //         element.round!.toLowerCase() ==
                              //             '3rd place final' &&
                              //         isWordcupLeague(element)))
                              //     .toList();
                              // finals = liveMatches
                              //     .where((element) => (element.round != null &&
                              //         element.round!.toLowerCase() == 'final' &&
                              //         isWordcupLeague(element)))
                              //     .toList();
                            }
                          }
                          return Container(
                              height: MediaQuery.of(context).size.height * 1.2,
                              width: MediaQuery.of(context).size.width * 2.2,
                              child: Column(children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Center(child: Text('8th Finals')),
                                    ),
                                    Expanded(
                                      child:
                                          Center(child: Text('Quarter Finals')),
                                    ),
                                    Expanded(
                                      child: Center(child: Text('Semi Finals')),
                                    ),
                                    Expanded(
                                      child: Center(
                                          child: Text('3rd Place Final')),
                                    ),
                                    Expanded(
                                      child: Center(child: Text('Final')),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: WC8thFinals(
                                            liveMatches: eightFinals,
                                            matches: match.length > 0 &&
                                                    match.first.league!.round!
                                                            .toLowerCase() ==
                                                        wc2022Round[0]
                                                ? match
                                                : null),
                                      ),
                                      Expanded(
                                        child: WCQuarterFinals(
                                            liveMatches: quarterFinals,
                                            matches: match.length > 0 &&
                                                    match.first.league!.round!
                                                            .toLowerCase() ==
                                                        wc2022Round[1]
                                                ? match
                                                : null),
                                      ),
                                      Expanded(
                                        child: WCSemiFinals(
                                            liveMatches: semiFinals,
                                            matches: match.length > 0 &&
                                                    match.first.league!.round!
                                                            .toLowerCase() ==
                                                        wc2022Round[2]
                                                ? match
                                                : null),
                                      ),
                                      Expanded(
                                        child: WC3rdPlace(
                                            liveMatches: thirdPlace,
                                            matches: match.length > 0 &&
                                                    match.first.league!.round!
                                                            .toLowerCase() ==
                                                        wc2022Round[3]
                                                ? match
                                                : null),
                                        // child: thirdplaceWidget()
                                      ),
                                      Expanded(
                                        child: WCFinals(
                                            liveMatches: finals,
                                            matches: match.length > 0 &&
                                                    match.first.league!.round!
                                                            .toLowerCase() ==
                                                        wc2022Round[4]
                                                ? match
                                                : null),
                                      ),
                                    ],
                                  ),
                                ),
                              ]));
                        } else {
                          return NoDataWidget();
                        }
                      });
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  thirdplaceWidget() {
    String matchHome = 'TBD';
    String matchAway = 'TBD';
    String matchHomeGoal = '0';
    String matchAwayGoal = '0';
    String matchDate = 'TBD';
    String matchTime = 'TBD';
    FootballMatch? thirdMatch;
    FootballMatch? matchOrNull;
    matchOrNull = liveMatches != null && liveMatches.length > 0
        ? liveMatches.first
        : null;
    // thirdMatch = match != null &&
    //         matchOrNull != null &&
    //         match!.first.fixture.id == matchOrNull!.fixture.id
    //     ? match!.first
    //     : matchOrNull;
    thirdMatch = match != null ? match.first : null;

    if (thirdMatch != null) {
      //name
      matchHome = thirdMatch.home.name;
      matchAway = thirdMatch.away.name;
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
      if (thirdMatch.goal != null) {
        if (thirdMatch.goal!.home != null) {
          matchHomeGoal = thirdMatch.goal!.home.toString();
        }
        if (thirdMatch.goal!.away != null) {
          matchAwayGoal = thirdMatch.goal!.away.toString();
        }
      }
    }

    matchDate = thirdMatch != null
        ? Constant.formattedDateMonth(
            (DateTime.parse(thirdMatch.fixture.date).toLocal()),
          )
        : matchDate;
    matchTime = thirdMatch != null
        ? Constant.formattedHMTime(
            (DateTime.parse(thirdMatch.fixture.date).toLocal()),
          )
        : matchTime;
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
                  color: Constant.color1,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                                              thirdMatch.home.logoUrl,
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
                                              thirdMatch.away.logoUrl,
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
