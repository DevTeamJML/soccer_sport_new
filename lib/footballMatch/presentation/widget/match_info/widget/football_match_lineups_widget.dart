import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_injuries.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_lineups.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/player_injuries.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/player_pos.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:transparent_image/transparent_image.dart';

class FootballMatchLineupsWidget extends StatefulWidget {
  final FootballMatch match;
  final FootballMatchBloc bloc;
  final List<Event> events;
  const FootballMatchLineupsWidget(
      {required this.match, required this.bloc, required this.events});

  @override
  State<FootballMatchLineupsWidget> createState() =>
      _FootballMatchLineupsWidgetState();
}

class _FootballMatchLineupsWidgetState
    extends State<FootballMatchLineupsWidget> {
  @override
  late FootballMatchBloc _footballMatchBloc;

  MatchLineups? homeMatchLineups;
  MatchLineups? awayMatchLineups;
  List<MatchInjuries> injuries = [];
  List<MatchInjuries>? homeMatchInjuries;
  List<MatchInjuries>? awayMatchInjuries;

  List<Event> events = [];
  List<Event> homeEvents = [];
  List<Event> awayEvents = [];
  bool isAfter = false;
  @override
  void initState() {
    super.initState();
    _footballMatchBloc = widget.bloc;
    var now = DateTime.now();
    var before40Match = DateTime.parse(widget.match.fixture.date)
        .toLocal()
        .subtract(Duration(minutes: 40));
    isAfter = now.isAfter(before40Match);

    if (isAfter) {
      events = widget.events;
      if (events.length > 0) {
        homeEvents = events
            .where((element) =>
                (element.team!.id == widget.match.home.id) &&
                (element.type != null &&
                    element.type!.toLowerCase() == "subst"))
            .toList();
        awayEvents = events
            .where((element) =>
                (element.team!.id == widget.match.away.id) &&
                (element.type != null &&
                    element.type!.toLowerCase() == "subst"))
            .toList();
      }
      _footballMatchBloc
          .add(GetMatchLineupsRequest(id: widget.match.fixture.id.toString()));
    } else {
      _footballMatchBloc
          .add(GetMatchInjuriesRequest(id: widget.match.fixture.id.toString()));
    }
  }

  Widget build(BuildContext context) {
    return StreamBuilder<List<FootballMatch>>(
        stream: Constant.liveData.stream,
        builder: (context, snapshot) {
          if (homeMatchLineups != null &&
              awayMatchLineups != null &&
              snapshot.hasData) {
            List<FootballMatch> liveMatches =
                snapshot.data != null ? snapshot.data! : [];
            FootballMatch? uMatch = liveMatches.firstWhereOrNull((e) {
              return e.fixture.id == widget.match.fixture.id;
            });

            if (uMatch != null) {
              events = (uMatch.events != null
                  ? uMatch.events!
                      .where((element) => (element.type != null))
                      .toList()
                  : []);

              homeEvents = events
                  .where((element) =>
                      (element.team!.id == widget.match.home.id) &&
                      (element.type != null &&
                          element.type!.toLowerCase() == "subst"))
                  .toList();
              awayEvents = events
                  .where((element) =>
                      (element.team!.id == widget.match.away.id) &&
                      (element.type != null &&
                          element.type!.toLowerCase() == "subst"))
                  .toList();
              // if (events.length > 0) {
              //   homeEvents = events
              //       .where((element) =>
              //           (element.team!.id == widget.match.home.id) &&
              //           (element.type != null &&
              //               element.type!.toLowerCase() == "subst"))
              //       .toList();
              //   awayEvents = events
              //       .where((element) =>
              //           (element.team!.id == widget.match.away.id) &&
              //           (element.type != null &&
              //               element.type!.toLowerCase() == "subst"))
              //       .toList();
              //   print("gotma ");
              //   print(homeEvents.length);
              //   print(awayEvents.length);
              // }
            }
          }
          return BlocListener<FootballMatchBloc, FootballMatchState>(
            bloc: _footballMatchBloc,
            listener: (context, state) {
              if (state is MatchLineupsGet) {
                setState(() {
                  if (state.stats.length > 0) {
                    homeMatchLineups = state.stats.firstWhere(
                        (element) => element.team.id == widget.match.home.id);
                    awayMatchLineups = state.stats.firstWhere(
                        (element) => element.team.id == widget.match.away.id);
                  }
                  if (events.length > 0) {
                    _footballMatchBloc.add(GetMatchInjuriesRequest(
                        id: widget.match.fixture.id.toString()));
                  } else {
                    _footballMatchBloc.add(GetMatchEventRequest(
                        id: widget.match.fixture.id.toString()));
                  }
                });
              }

              if (state is MatchInjuriesGet) {
                setState(() {
                  injuries = state.stats;

                  homeMatchInjuries = injuries
                      .where(
                          (element) => element.team.id == widget.match.home.id)
                      .toList();
                  awayMatchInjuries = injuries
                      .where(
                          (element) => element.team.id == widget.match.away.id)
                      .toList();
                });
              }

              if (state is MatchEventGet) {
                setState(() {
                  events = state.stats;

                  if (events.length > 0) {
                    homeEvents = events
                        .where((element) =>
                            (element.team!.id == widget.match.home.id) &&
                            (element.type != null &&
                                element.type!.toLowerCase() == "subst"))
                        .toList();
                    awayEvents = events
                        .where((element) =>
                            (element.team!.id == widget.match.away.id) &&
                            (element.type != null &&
                                element.type!.toLowerCase() == "subst"))
                        .toList();
                  }
                  _footballMatchBloc.add(GetMatchInjuriesRequest(
                      id: widget.match.fixture.id.toString()));
                });
              }
            },
            child: BlocBuilder<FootballMatchBloc, FootballMatchState>(
              bloc: _footballMatchBloc,
              builder: (context, state) {
                var height = MediaQuery.of(context).size.height;
                var imageHeight = height * 0.9;
                if ((state is GettingMatchLineups ||
                    state is MatchLineupsGet ||
                    state is GettingMatchEvent ||
                    state is GettingMatchInjuries)) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      width: double.infinity,
                      child: LoadingWidget());
                } else if (state is FootballMatchesError) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      width: double.infinity,
                      child: ErrorWidget(state.message));
                } else {
                  if (state is MatchInjuriesGet) {
                    // if (  isAfter ?  (homeMatchLineups != null && awayMatchLineups != null) : ) {

                    // } else {
                    //   print('not lastone');
                    //   return Container(
                    //       height: MediaQuery.of(context).size.height * 0.75,
                    //       child: NoDataWidget());
                    // }

                    int maxLength = [
                      awayEvents.length,
                      homeEvents.length
                    ].reduce(
                        (value, element) => value > element ? value : element);
                    int maxInjuriesLength = 0;

                    if (injuries.length > 0)
                      maxInjuriesLength = [
                        awayMatchInjuries!.length,
                        homeMatchInjuries!.length
                      ].reduce((value, element) =>
                          value > element ? value : element);
                    int subMaxLength = homeMatchLineups != null
                        ? [
                            homeMatchLineups!.substitutes.length,
                            awayMatchLineups!.substitutes.length
                          ].reduce((value, element) =>
                            value > element ? value : element)
                        : 0;
                    var maxHomeCols = homeMatchLineups != null &&
                            homeMatchLineups!.formation != null
                        ? homeMatchLineups!.formation!.split("-").length
                        : 0;
                    var maxAwayCols = awayMatchLineups != null &&
                            awayMatchLineups!.formation != null
                        ? awayMatchLineups!.formation!.split("-").length
                        : 0;

                    var homeFormation = awayMatchLineups != null &&
                            homeMatchLineups!.formation != null
                        ? homeMatchLineups!.formation!
                            .split("-")
                            .map((e) => int.parse(e))
                            .toList()
                        : [];
                    var awayFormation = awayMatchLineups != null &&
                            awayMatchLineups!.formation != null
                        ? awayMatchLineups!.formation!
                            .split("-")
                            .map((e) => int.parse(e))
                            .toList()
                        : [];
                    if (homeMatchLineups != null && homeMatchInjuries != null) {
                      return Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom),
                          height: (awayMatchLineups != null ? imageHeight : 0) +
                              ((subMaxLength * (height * 0.05)) +
                                  (subMaxLength > 0 ? height * 0.025 : 0)) +
                              (((height * 0.1) * maxLength) +
                                  (maxLength > 0 ? height * 0.025 : 0)) +
                              (maxInjuriesLength > 0
                                  ? (((height * 0.08) * maxInjuriesLength) +
                                      height * 0.025)
                                  : 0),
                          child: ListView(
                            children: [
                              if (awayMatchLineups != null &&
                                  homeMatchLineups != null &&
                                  awayMatchLineups!.formation != null &&
                                  homeMatchLineups!.formation != null)
                                Stack(
                                  children: [
                                    Container(
                                      height: imageHeight,
                                      width: double.infinity,
                                      child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Image.asset(
                                              'assets/lineups_bg2.jpg')),
                                    ),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                        height: imageHeight,
                                        child: ListView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: [
                                            Container(
                                              height: height * 0.05,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  homeMatchLineups!.team.name! +
                                                      " " +
                                                      (homeMatchLineups!
                                                                  .formation !=
                                                              null
                                                          ? homeMatchLineups!
                                                              .formation!
                                                          : ""),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: height * 0.4,
                                              child: Column(
                                                // physics:
                                                //     NeverScrollableScrollPhysics(),
                                                children: List.generate(
                                                    maxHomeCols + 1,
                                                    (rowIndex) {
                                                  return Expanded(
                                                    // flex: rowIndex == 0 ? 2 : 1,
                                                    child: Row(
                                                      children: List.generate(
                                                          rowIndex == 0
                                                              ? 1
                                                              : homeFormation[
                                                                  rowIndex - 1],
                                                          (colIndex) {
                                                        PlayerPos player =
                                                            homeMatchLineups!
                                                                .startXI
                                                                .firstWhere(
                                                                    (e) {
                                                          var gridList = e.grid!
                                                              .split(":")
                                                              .map((e) =>
                                                                  int.parse(e))
                                                              .toList();

                                                          return (gridList[0] -
                                                                      1) ==
                                                                  rowIndex &&
                                                              (gridList)[1] -
                                                                      1 ==
                                                                  colIndex;
                                                        });

                                                        List<
                                                            Event> playerEvent = events
                                                                    .length >
                                                                0
                                                            ? events
                                                                .where((element) =>
                                                                    (element.player !=
                                                                            null &&
                                                                        element.player!.id ==
                                                                            player
                                                                                .id) ||
                                                                    (element.assist !=
                                                                            null &&
                                                                        element.assist!.id !=
                                                                            null &&
                                                                        element.assist!.id ==
                                                                            player.id))
                                                                .toList()
                                                                .reversed
                                                                .toList()
                                                            : [];

                                                        Event? playerCardEvent;
                                                        Event? playerSubstEvent;
                                                        Event? playerGoalEvent;
                                                        if (playerEvent.length >
                                                            0) {
                                                          playerCardEvent = playerEvent.firstWhereOrNull(
                                                              (element) => (element
                                                                          .type !=
                                                                      null &&
                                                                  element.type!
                                                                          .toLowerCase() ==
                                                                      "card"));
                                                          playerSubstEvent = playerEvent.firstWhereOrNull((element) =>
                                                              element.type !=
                                                                  null &&
                                                              element.type!
                                                                      .toLowerCase() ==
                                                                  "subst" &&
                                                              element.assist !=
                                                                  null &&
                                                              element.assist!
                                                                      .id !=
                                                                  null &&
                                                              element.assist!
                                                                      .id ==
                                                                  player.id);

                                                          playerGoalEvent = playerEvent.firstWhereOrNull((element) =>
                                                              (((element.type != null && element.type!.toLowerCase() == "goal") &&
                                                                      (element.detail != null &&
                                                                          element.detail!.toLowerCase() !=
                                                                              "missed penalty")) ||
                                                                  ((element.type != null &&
                                                                          element.type!.toLowerCase() ==
                                                                              "var") &&
                                                                      (element.detail != null &&
                                                                          element.detail!.toLowerCase() !=
                                                                              "goal cancelled"))) &&
                                                              (element.player !=
                                                                      null &&
                                                                  element.player!
                                                                          .id ==
                                                                      player.id));
                                                        }
                                                        return Expanded(
                                                          child: Container(
                                                              // decoration:
                                                              //     BoxDecoration(
                                                              //   border: Border.all(
                                                              //     color: Colors
                                                              //         .grey.shade300,
                                                              //     width: 1.0,
                                                              //   ),
                                                              // ),

                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomCenter,
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          40,
                                                                      width: 40,

                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          right:
                                                                              5,
                                                                          left:
                                                                              5),
                                                                      child:
                                                                          Stack(
                                                                        alignment:
                                                                            AlignmentDirectional.center,
                                                                        children: [
                                                                          // Icon(
                                                                          //   // FontAwesomeIcons
                                                                          //   //     .tshirt,

                                                                          //   MdiIcons
                                                                          //       .tshirtCrew,
                                                                          //   size: 40,
                                                                          // ),
                                                                          Container(
                                                                              height: 35,
                                                                              width: 35,
                                                                              child: Image.asset('assets/home_icon.png')),
                                                                          Center(
                                                                            child:
                                                                                Text(
                                                                              player.number.toString(),
                                                                              style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                      //     CircleAvatar(
                                                                      //   child: Text(
                                                                      //     player
                                                                      //         .number
                                                                      //         .toString(),
                                                                      //     style: TextStyle(
                                                                      //         color: Colors
                                                                      //             .white,
                                                                      //         fontSize:
                                                                      //             11,
                                                                      //         fontWeight:
                                                                      //             FontWeight.bold),
                                                                      //   ),
                                                                      //   backgroundColor:
                                                                      //       Colors
                                                                      //           .black,
                                                                      // ),
                                                                    ),
                                                                    if (playerSubstEvent !=
                                                                        null)
                                                                      Positioned(
                                                                        right:
                                                                            0.5,
                                                                        bottom:
                                                                            0.5,
                                                                        child: Icon(
                                                                            MdiIcons
                                                                                .arrowDownBold,
                                                                            color:
                                                                                Constant.color1,
                                                                            size: 15),
                                                                      ),
                                                                    if (playerCardEvent !=
                                                                            null &&
                                                                        playerCardEvent.detail !=
                                                                            null)
                                                                      Positioned(
                                                                          right:
                                                                              0.5,
                                                                          top:
                                                                              0.5,
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                13,
                                                                            width:
                                                                                9,
                                                                            color: playerCardEvent.detail!.toLowerCase().split(" ").contains("yellow")
                                                                                ? Colors.yellow
                                                                                : Colors.red,
                                                                          )),
                                                                    if (playerGoalEvent !=
                                                                        null)
                                                                      Positioned(
                                                                        left:
                                                                            0.5,
                                                                        top:
                                                                            0.5,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              15,
                                                                          width:
                                                                              15,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child: Icon(
                                                                              FontAwesomeIcons.futbol,
                                                                              color: Colors.black,
                                                                              size: 15),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                                // SizedBox(
                                                                //   height: 5,
                                                                // ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        AutoSizeText(
                                                                      player
                                                                          .name,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      softWrap:
                                                                          true,
                                                                      wrapWords:
                                                                          false,
                                                                      maxLines:
                                                                          2,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      maxFontSize:
                                                                          12,
                                                                      minFontSize:
                                                                          8,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ])),
                                                        );
                                                      }).reversed.toList(),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                            Container(
                                              height: height * 0.4,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                // physics: NeverScrollableScrollPhysics(),
                                                children: List.generate(
                                                    maxAwayCols + 1,
                                                    (rowIndex) {
                                                  return Expanded(
                                                    // flex: rowIndex == 0 ? 2 : 1,
                                                    child: Container(
                                                      child: Row(
                                                          children: List.generate(
                                                              rowIndex == 0
                                                                  ? 1
                                                                  : awayFormation[
                                                                      rowIndex -
                                                                          1],
                                                              (colIndex) {
                                                        PlayerPos player =
                                                            awayMatchLineups!
                                                                .startXI
                                                                .firstWhere(
                                                                    (e) {
                                                          var gridList = e.grid!
                                                              .split(":")
                                                              .map((e) =>
                                                                  int.parse(e))
                                                              .toList();
                                                          return (gridList[0] -
                                                                      1) ==
                                                                  rowIndex &&
                                                              (gridList)[1] -
                                                                      1 ==
                                                                  colIndex;
                                                        });
                                                        List<
                                                            Event> playerEvent = events
                                                                    .length >
                                                                0
                                                            ? events
                                                                .where((element) => (element
                                                                            .player!
                                                                            .id ==
                                                                        player
                                                                            .id ||
                                                                    (element
                                                                                .assist !=
                                                                            null &&
                                                                        element.assist!.id !=
                                                                            null &&
                                                                        element.assist!.id ==
                                                                            player.id)))
                                                                .toList()
                                                                .reversed
                                                                .toList()
                                                            : [];

                                                        Event? playerCardEvent;
                                                        Event? playerSubstEvent;
                                                        Event? playerGoalEvent;
                                                        if (playerEvent.length >
                                                            0) {
                                                          playerCardEvent = playerEvent.firstWhereOrNull((element) =>
                                                              element.type !=
                                                                  null &&
                                                              element.type!
                                                                      .toLowerCase() ==
                                                                  "card" &&
                                                              (element.player !=
                                                                      null &&
                                                                  element.player!
                                                                          .id ==
                                                                      player
                                                                          .id));
                                                          playerSubstEvent = playerEvent.firstWhereOrNull((element) =>
                                                              element.type !=
                                                                  null &&
                                                              element.type!
                                                                      .toLowerCase() ==
                                                                  "subst" &&
                                                              element.assist !=
                                                                  null &&
                                                              element.assist!
                                                                      .id !=
                                                                  null &&
                                                              element.assist!
                                                                      .id ==
                                                                  player.id);
                                                          playerGoalEvent = playerEvent.firstWhereOrNull((element) =>
                                                              (((element.type != null && element.type!.toLowerCase() == "goal") &&
                                                                      (element.detail != null &&
                                                                          element.detail!.toLowerCase() !=
                                                                              "missed penalty")) ||
                                                                  ((element.type != null &&
                                                                          element.type!.toLowerCase() ==
                                                                              "var") &&
                                                                      (element.detail != null &&
                                                                          element.detail!.toLowerCase() !=
                                                                              "goal cancelled"))) &&
                                                              (element.player !=
                                                                      null &&
                                                                  element.player!
                                                                          .id ==
                                                                      player.id));
                                                        }
                                                        return Expanded(
                                                          child: Container(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                Stack(
                                                                  children: [
                                                                    // Container(
                                                                    //   height: 30,
                                                                    //   width: 30,
                                                                    //   margin: EdgeInsets
                                                                    //       .only(
                                                                    //           top: 5,
                                                                    //           right:
                                                                    //               5,
                                                                    //           left:
                                                                    //               5),
                                                                    //   child:
                                                                    //       CircleAvatar(
                                                                    //     child: Text(
                                                                    //       player
                                                                    //           .number
                                                                    //           .toString(),
                                                                    //       style: TextStyle(
                                                                    //           color: Colors
                                                                    //               .black,
                                                                    //           fontSize:
                                                                    //               11,
                                                                    //           fontWeight:
                                                                    //               FontWeight.bold),
                                                                    //     ),
                                                                    //     backgroundColor:
                                                                    //         Colors
                                                                    //             .white,
                                                                    //   ),
                                                                    // ),

                                                                    Container(
                                                                      height:
                                                                          40,
                                                                      width: 40,
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          right:
                                                                              5,
                                                                          left:
                                                                              5),
                                                                      child:
                                                                          Stack(
                                                                        alignment:
                                                                            AlignmentDirectional.center,
                                                                        children: [
                                                                          Container(
                                                                              height: 35,
                                                                              width: 35,
                                                                              child: Image.asset('assets/away_icon.png')),
                                                                          Center(
                                                                            child:
                                                                                Text(
                                                                              player.number.toString(),
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    if (playerSubstEvent !=
                                                                        null)
                                                                      Positioned(
                                                                        right:
                                                                            0.5,
                                                                        bottom:
                                                                            0.5,
                                                                        child: Icon(
                                                                            MdiIcons
                                                                                .arrowDownBold,
                                                                            color:
                                                                                Constant.color1,
                                                                            size: 15),
                                                                      ),
                                                                    if (playerCardEvent !=
                                                                            null &&
                                                                        playerCardEvent.detail !=
                                                                            null)
                                                                      Positioned(
                                                                          right:
                                                                              0.5,
                                                                          top:
                                                                              0.5,
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                13,
                                                                            width:
                                                                                9,
                                                                            color: playerCardEvent.detail!.toLowerCase().split(" ").contains("yellow")
                                                                                ? Colors.yellow
                                                                                : Colors.red,
                                                                          )),
                                                                    if (playerGoalEvent !=
                                                                        null)
                                                                      Positioned(
                                                                        left:
                                                                            0.5,
                                                                        top:
                                                                            0.5,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              15,
                                                                          width:
                                                                              15,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child: Icon(
                                                                              FontAwesomeIcons.futbol,
                                                                              color: Colors.black,
                                                                              size: 15),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      Container(
                                                                    child: AutoSizeText(
                                                                        player
                                                                            .name,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        softWrap:
                                                                            true,
                                                                        wrapWords:
                                                                            false,
                                                                        maxLines:
                                                                            2,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold),
                                                                        maxFontSize:
                                                                            12,
                                                                        minFontSize:
                                                                            8),
                                                                  ),
                                                                ),
                                                              ])),
                                                        );
                                                      })),
                                                    ),
                                                  );
                                                }).reversed.toList(),
                                              ),
                                            ),
                                            Container(
                                              height: height * 0.05,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  awayMatchLineups!.team.name! +
                                                      " " +
                                                      (awayMatchLineups!
                                                                  .formation !=
                                                              null
                                                          ? awayMatchLineups!
                                                              .formation!
                                                          : ""),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              if (events.length > 0 && maxLength > 0)
                                Container(
                                    height: ((height * 0.1) * (maxLength)) +
                                        height * 0.025 +
                                        (height * 0.025) +
                                        20,
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        vertical: 10),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            height: height * 0.025,
                                            child: Text(
                                              "Substitution Events",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0),
                                                ),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 0.5)),
                                            child: Column(
                                                children: List.generate(
                                                    maxLength + 1, (index) {
                                              Event? awayEvent = index != 0
                                                  ? (awayEvents.length >
                                                          index - 1
                                                      ? awayEvents[index - 1]
                                                      : null)
                                                  : null;
                                              Event? homeEvent = index != 0
                                                  ? (homeEvents.length >
                                                          index - 1
                                                      ? homeEvents[index - 1]
                                                      : null)
                                                  : null;
                                              return Expanded(
                                                flex: index == 0 ? 1 : 2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: index == 0
                                                          ? Constant.color1
                                                          : Colors.transparent,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 0.5))),
                                                  child: Row(
                                                    children: [
                                                      homeEvent != null ||
                                                              index == 0
                                                          ? Expanded(
                                                              child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              child: Row(
                                                                children: [
                                                                  if (index !=
                                                                      0)
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                      child:
                                                                          Text(
                                                                        homeEvent!.time.elapsed.toString() +
                                                                            "'",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              11,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  index != 0
                                                                      ? Expanded(
                                                                          child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(right: 5),
                                                                                      child: Icon(MdiIcons.arrowDownBold, color: Constant.color1, size: 20),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: AutoSizeText(
                                                                                        (homeEvent!.assist != null && homeEvent.assist!.name != null) ? homeEvent.assist!.name! : "",
                                                                                        // style: TextStyle(fontWeight: FontWeight.bold),
                                                                                        maxFontSize: index == 0 ? 12 : 10,
                                                                                        minFontSize: 8,
                                                                                        softWrap: true,
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(right: 5),
                                                                                      child: Icon(MdiIcons.arrowUpBold, color: Colors.green, size: 20),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: AutoSizeText(
                                                                                        (homeEvent.player != null && homeEvent.player!.name != null) ? homeEvent.player!.name! : "",
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                        maxFontSize: index == 0 ? 12 : 10,
                                                                                        minFontSize: 8,
                                                                                        softWrap: true,
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ]),
                                                                        )
                                                                      : Expanded(
                                                                          child: AutoSizeText(
                                                                              homeMatchLineups!.team.name != null ? homeMatchLineups!.team.name! : "",
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                              maxFontSize: index == 0 ? 12 : 10,
                                                                              minFontSize: 8,
                                                                              softWrap: true,
                                                                              maxLines: 1,
                                                                              textAlign: TextAlign.center),
                                                                        )
                                                                ],
                                                              ),
                                                            ))
                                                          : Expanded(
                                                              child:
                                                                  Container()),
                                                      awayEvent != null ||
                                                              index == 0
                                                          ? Expanded(
                                                              child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              child: Row(
                                                                children: [
                                                                  if (index !=
                                                                      0)
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                      child:
                                                                          Text(
                                                                        awayEvent!.time.elapsed.toString() +
                                                                            "'",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              11,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  index != 0
                                                                      ? Expanded(
                                                                          child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(right: 5),
                                                                                      child: Icon(MdiIcons.arrowDownBold, color: Constant.color1, size: 20),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: AutoSizeText(
                                                                                        (awayEvent!.assist != null && awayEvent.assist!.name != null) ? awayEvent.assist!.name! : "",
                                                                                        // style: TextStyle(fontWeight: FontWeight.bold),
                                                                                        maxFontSize: index == 0 ? 12 : 10,
                                                                                        minFontSize: 8,
                                                                                        softWrap: true,
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(right: 5),
                                                                                      child: Icon(MdiIcons.arrowUpBold, color: Colors.green, size: 20),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: AutoSizeText(
                                                                                        (awayEvent.player != null && awayEvent.player!.name != null) ? awayEvent.player!.name! : "",
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                        maxFontSize: index == 0 ? 12 : 10,
                                                                                        minFontSize: 8,
                                                                                        softWrap: true,
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ]),
                                                                        )
                                                                      : Expanded(
                                                                          child: AutoSizeText(
                                                                              awayMatchLineups!.team.name != null ? awayMatchLineups!.team.name! : "",
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                              maxFontSize: index == 0 ? 12 : 10,
                                                                              minFontSize: 8,
                                                                              softWrap: true,
                                                                              maxLines: 1,
                                                                              textAlign: TextAlign.center),
                                                                        )
                                                                ],
                                                              ),
                                                            ))
                                                          : Expanded(
                                                              child:
                                                                  Container()),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })),
                                          ),
                                        )
                                      ],
                                    )),
                              if (homeMatchLineups != null &&
                                  awayMatchLineups != null)
                                Container(
                                  height:
                                      ((subMaxLength + 1) * (height * 0.05)) +
                                          height * 0.025,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      vertical: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          height: height * 0.025,
                                          child: Text(
                                            "Substitute Players List",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0),
                                                ),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 0.5)),
                                            child: Column(
                                                children: List.generate(
                                                    subMaxLength + 1, (index) {
                                              PlayerPos? homeSub = index != 0
                                                  ? (homeMatchLineups!
                                                              .substitutes
                                                              .length >
                                                          index - 1
                                                      ? homeMatchLineups!
                                                              .substitutes[
                                                          index - 1]
                                                      : null)
                                                  : null;

                                              PlayerPos? awaySub = index != 0
                                                  ? (awayMatchLineups!
                                                              .substitutes
                                                              .length >
                                                          index - 1
                                                      ? awayMatchLineups!
                                                              .substitutes[
                                                          index - 1]
                                                      : null)
                                                  : null;
                                              List<Event> homeAllEvent =
                                                  homeSub != null
                                                      ? events
                                                          .where((e) =>
                                                              (e.player!.id ==
                                                                  homeSub.id))
                                                          .toList()
                                                      : [];

                                              Event? homeYellow = homeAllEvent
                                                          .length >
                                                      0
                                                  ? homeAllEvent.reversed
                                                      .firstWhereOrNull((e) => (e
                                                                  .type !=
                                                              null &&
                                                          e.type!.toLowerCase() ==
                                                              "card"))
                                                  : null;
                                              Event? homeGoal = homeAllEvent
                                                          .length >
                                                      0
                                                  ? homeAllEvent.reversed
                                                      .firstWhereOrNull((e) => (e
                                                                  .type !=
                                                              null &&
                                                          e.type!.toLowerCase() ==
                                                              "goal"))
                                                  : null;

                                              List<Event> awayAllEvent =
                                                  awaySub != null
                                                      ? events
                                                          .where((e) =>
                                                              (e.player!.id ==
                                                                  awaySub.id))
                                                          .toList()
                                                      : [];
                                              Event? awayYellow = awayAllEvent
                                                          .length >
                                                      0
                                                  ? awayAllEvent.reversed
                                                      .firstWhereOrNull((e) => (e
                                                                  .type !=
                                                              null &&
                                                          e.type!.toLowerCase() ==
                                                              "card"))
                                                  : null;

                                              // print(awayYellow != null
                                              //     ? "got card!!1"
                                              //     : awayYellow!.team!.id);
                                              Event? awayGoal = awayAllEvent !=
                                                      null
                                                  ? awayAllEvent.reversed
                                                      .firstWhereOrNull((e) => (e
                                                                  .type !=
                                                              null &&
                                                          e.type!.toLowerCase() ==
                                                              "goal"))
                                                  : null;

                                              return Expanded(
                                                child: Container(
                                                  // height: height * 0.042,
                                                  decoration: BoxDecoration(
                                                      color: index == 0
                                                          ? Constant.color1
                                                          : Colors.transparent,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 0.5))),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Row(children: [
                                                            if (index != 0)
                                                              homeSub != null
                                                                  ? Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              2.0),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Stack(
                                                                            alignment:
                                                                                AlignmentDirectional.center,
                                                                            children: [
                                                                              Container(margin: EdgeInsets.symmetric(horizontal: 5), height: 30, width: 30, child: Image.asset('assets/home_icon.png')),
                                                                              Center(
                                                                                child: Text(
                                                                                  homeSub.number.toString(),
                                                                                  style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          if (homeYellow != null &&
                                                                              homeYellow.detail != null)
                                                                            Positioned(
                                                                                right: 0.5,
                                                                                top: 0.5,
                                                                                child: Container(
                                                                                  height: 8,
                                                                                  width: 5,
                                                                                  color: homeYellow.detail!.toLowerCase().split(" ").contains("yellow") ? Colors.yellow : Colors.red,
                                                                                )),
                                                                          if (homeEvents.length > 0 &&
                                                                              homeEvents.firstWhereOrNull((element) => element.player != null && element.player!.id == homeSub.id) != null)
                                                                            Positioned(
                                                                              right: 0.1,
                                                                              bottom: 0.1,
                                                                              child: Icon(MdiIcons.arrowUpBold, color: Colors.green, size: 15),
                                                                            ),
                                                                          if (homeGoal !=
                                                                              null)
                                                                            Positioned(
                                                                              left: 0.5,
                                                                              top: 0.5,
                                                                              child: Container(
                                                                                height: 15,
                                                                                width: 15,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                child: Icon(FontAwesomeIcons.futbol, color: Colors.black, size: 15),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            if (homeSub !=
                                                                    null ||
                                                                index == 0)
                                                              Expanded(
                                                                child: AutoSizeText(
                                                                    index == 0
                                                                        ? homeMatchLineups!
                                                                            .team
                                                                            .name!
                                                                        : homeSub!
                                                                            .name,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                    maxFontSize:
                                                                        index ==
                                                                                0
                                                                            ? 12
                                                                            : 10,
                                                                    minFontSize:
                                                                        8,
                                                                    softWrap:
                                                                        true,
                                                                    maxLines: 1,
                                                                    textAlign: index ==
                                                                            0
                                                                        ? TextAlign
                                                                            .center
                                                                        : null),
                                                              ),
                                                          ]),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Row(children: [
                                                            if (index != 0)
                                                              awaySub != null
                                                                  ? Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              2.0),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Stack(
                                                                            alignment:
                                                                                AlignmentDirectional.center,
                                                                            children: [
                                                                              Container(margin: EdgeInsets.symmetric(horizontal: 5), height: 30, width: 30, child: Image.asset('assets/away_icon.png')),
                                                                              Center(
                                                                                child: Text(
                                                                                  awaySub.number.toString(),
                                                                                  style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          if (awayYellow != null &&
                                                                              awayYellow.detail != null)
                                                                            Positioned(
                                                                                right: 1,
                                                                                top: 0.5,
                                                                                child: Container(
                                                                                  height: 10,
                                                                                  width: 8,
                                                                                  color: awayYellow.detail!.toLowerCase().split(" ").contains("yellow") ? Colors.yellow : Colors.red,
                                                                                )),
                                                                          if (awayEvents.length > 0 &&
                                                                              awayEvents.firstWhereOrNull((element) => element.player != null && element.player!.id == awaySub.id) != null)
                                                                            Positioned(
                                                                              right: 0.1,
                                                                              bottom: 0.1,
                                                                              child: Icon(MdiIcons.arrowUpBold, color: Colors.green, size: 15),
                                                                            ),
                                                                          if (awayGoal !=
                                                                              null)
                                                                            Positioned(
                                                                              left: 0.5,
                                                                              top: 0.5,
                                                                              child: Container(
                                                                                height: 15,
                                                                                width: 15,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                child: Icon(FontAwesomeIcons.futbol, color: Colors.black, size: 15),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            if (awaySub !=
                                                                    null ||
                                                                index == 0)
                                                              Expanded(
                                                                child: AutoSizeText(
                                                                    index == 0
                                                                        ? awayMatchLineups!
                                                                            .team
                                                                            .name!
                                                                        : awaySub!
                                                                            .name,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                    maxFontSize:
                                                                        index ==
                                                                                0
                                                                            ? 12
                                                                            : 10,
                                                                    minFontSize:
                                                                        8,
                                                                    softWrap:
                                                                        true,
                                                                    maxLines: 1,
                                                                    textAlign: index ==
                                                                            0
                                                                        ? TextAlign
                                                                            .center
                                                                        : null),
                                                              ),
                                                          ]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }))),
                                      )
                                    ],
                                  ),
                                ),
                              if (maxInjuriesLength > 0)
                                Container(
                                    height: (maxInjuriesLength > 0
                                        ? (((height * 0.08) *
                                                maxInjuriesLength) +
                                            height * 0.025)
                                        : 0),
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        vertical: 10),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            height: height * 0.025,
                                            child: Text(
                                              "Injuries Players List",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0),
                                                ),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 0.5)),
                                            child: Column(
                                              children: List.generate(
                                                  maxInjuriesLength + 1,
                                                  (index) {
                                                MatchInjuries? homePlayerInju =
                                                    index != 0
                                                        ? (homeMatchInjuries!
                                                                    .length >
                                                                index - 1
                                                            ? homeMatchInjuries![
                                                                index - 1]
                                                            : null)
                                                        : null;
                                                MatchInjuries? awayPlayerInju =
                                                    index != 0
                                                        ? (awayMatchInjuries!
                                                                    .length >
                                                                index - 1
                                                            ? awayMatchInjuries![
                                                                index - 1]
                                                            : null)
                                                        : null;

                                                return Expanded(
                                                  flex: index == 0 ? 1 : 2,
                                                  child: Container(
                                                    // height: height * 0.042,
                                                    decoration: BoxDecoration(
                                                        color: index == 0
                                                            ? Constant.color1
                                                            : Colors
                                                                .transparent,
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.5))),
                                                    child: Row(
                                                      children: [
                                                        homePlayerInju !=
                                                                    null ||
                                                                index == 0
                                                            ? Expanded(
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  child: Row(
                                                                      children: [
                                                                        if (index !=
                                                                            0)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(5.0),
                                                                            child:
                                                                                Icon(
                                                                              FontAwesomeIcons.briefcaseMedical,
                                                                              color: Colors.red,
                                                                            ),
                                                                          ),
                                                                        index !=
                                                                                0
                                                                            ? Expanded(
                                                                                child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  AutoSizeText(index == 0 ? widget.match.home.name : homePlayerInju!.player.name, style: TextStyle(fontWeight: FontWeight.bold), maxFontSize: index == 0 ? 12 : 10, minFontSize: 8, softWrap: true, maxLines: 1, textAlign: index == 0 ? TextAlign.center : null),
                                                                                  SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  AutoSizeText(index == 0 ? widget.match.home.name : homePlayerInju!.player.reason, maxFontSize: index == 0 ? 12 : 10, minFontSize: 8, softWrap: true, maxLines: 1, textAlign: index == 0 ? TextAlign.center : null),
                                                                                ],
                                                                              ))
                                                                            : Expanded(
                                                                                child: AutoSizeText(widget.match.home.name, maxFontSize: index == 0 ? 12 : 10, minFontSize: 8, softWrap: true, maxLines: 1, textAlign: index == 0 ? TextAlign.center : null),
                                                                              ),
                                                                      ]),
                                                                ),
                                                              )
                                                            : Expanded(
                                                                child:
                                                                    Container()),
                                                        awayPlayerInju !=
                                                                    null ||
                                                                index == 0
                                                            ? Expanded(
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  child: Row(
                                                                      children: [
                                                                        if (index !=
                                                                            0)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(5.0),
                                                                            child:
                                                                                Icon(FontAwesomeIcons.briefcaseMedical, color: Colors.red),
                                                                          ),
                                                                        index !=
                                                                                0
                                                                            ? Expanded(
                                                                                child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  AutoSizeText(index == 0 ? widget.match.away.name : awayPlayerInju!.player.name, style: TextStyle(fontWeight: FontWeight.bold), maxFontSize: index == 0 ? 12 : 10, minFontSize: 8, softWrap: true, maxLines: 1, textAlign: index == 0 ? TextAlign.center : null),
                                                                                  SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  AutoSizeText(index == 0 ? widget.match.away.name : awayPlayerInju!.player.reason, maxFontSize: index == 0 ? 12 : 10, minFontSize: 8, softWrap: true, maxLines: 1, textAlign: index == 0 ? TextAlign.center : null),
                                                                                ],
                                                                              ))
                                                                            : Expanded(
                                                                                child: AutoSizeText(widget.match.away.name, maxFontSize: index == 0 ? 12 : 10, minFontSize: 8, softWrap: true, maxLines: 1, textAlign: index == 0 ? TextAlign.center : null),
                                                                              ),
                                                                      ]),
                                                                ),
                                                              )
                                                            : Expanded(
                                                                child:
                                                                    Container(),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        )
                                      ],
                                    ))
                            ],
                          ));
                    } else {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: NoDataWidget());
                    }
                  } else {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: NoDataWidget());
                  }
                }
              },
            ),
          );
        });
  }
}
