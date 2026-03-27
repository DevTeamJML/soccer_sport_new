import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/favorite_match/presentation/bloc/favorite_match_bloc.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event%20subentities/time.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/check_fixture_on_live.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:collection/collection.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/bet_button.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_away_widget.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_events_text.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_home_widget.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/match_info/football_match_info.dart';
import '../../../injection_container.dart';
import 'package:collection/collection.dart';

class FootballMatchListTile extends StatefulWidget {
  final FootballMatch footballMatch;
  final bool isIncoming;
  final bool live;
  final Function? refresh;
  final bool? showcasebool;
  final bool? availableToBet;
  final bool? isFavTab;
  final Key key;
  FootballMatchListTile({
    required this.key,
    required this.footballMatch,
    required this.isIncoming,
    required this.live,
    this.refresh,
    this.showcasebool,
    this.availableToBet,
    this.isFavTab,
  }) : super(key: key);

  @override
  _FootballMatchListTileState createState() => _FootballMatchListTileState();
}

class _FootballMatchListTileState extends State<FootballMatchListTile> {
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();
  int extraTime = 0;
  late FootballMatch match;
  List<Event>? awayEvent;
  List<Event>? homeEvent;

  final FavoriteMatchBloc _favoriteMatchBloc =
      serviceLocator<FavoriteMatchBloc>();
  bool afterFiveMin = false;
  bool matchOngoing = false;
  bool isFavorite = false;
  @override
  void initState() {
    match = widget.footballMatch;
    if (match.events != null &&
        match.events!.length > 0 &&
        (match.fixture.status.short == '1H' &&
                match.fixture.status.elapsedTime == 45 ||
            match.fixture.status.short == '2H' &&
                match.fixture.status.elapsedTime == 90) &&
        match.events!.last.time.extra != null) {
      extraTime = match.events!.last.time.extra!;
    } else {
      extraTime = 0;
    }

    if (match.events != null) {
      awayEvent = match.events!
          .where((element) =>
              element.team != null && element.team!.id == match.away.id)
          .toList();
      homeEvent = match.events!
          .where((element) =>
              element.team != null && element.team!.id == match.home.id)
          .toList();
    }

    matchOngoing = (match.fixture.status.short != 'FT' &&
        match.fixture.status.short != 'AET' &&
        match.fixture.status.short != 'PEN');
    isFavorite = Constant.favoriteList.firstWhereOrNull(
            (element) => element.fixture.id == match.fixture.id) !=
        null;
    afterFiveMin = DateTime.now().toLocal().isAfter(
        DateTime.parse(match.fixture.date)
            .toLocal()
            .subtract(Duration(minutes: 5)));

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (Constant.showcaseBool &&
          widget.showcasebool != null &&
          widget.showcasebool! &&
          !(widget.isIncoming) &&
          widget.footballMatch.league!.id == 39) {
        // ShowCaseWidget.of(context).startShowCase([
        //   Constant.matchIncomingKey,
        // ]);
      }
      if (Constant.showcaseBool &&
          widget.showcasebool != null &&
          widget.showcasebool! &&
          widget.isIncoming) {
        setState(() {
          // ShowCaseWidget.of(context).startShowCase([
          //   _key1,
          //   _key2,
          //   Constant.matchBetKey,
          //   Constant.betMatchInfo,
          // ]);
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _favoriteMatchBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _favoriteMatchBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<FootballMatchBloc, FootballMatchState>(
            listener: (context, state) {},
          ),
          BlocListener<FavoriteMatchBloc, FavoriteMatchState>(
            listener: (context, state) {
              if (state is FavoriteMatchPersisted) {
                if (state.footballMatches) {
                  setState(() {
                    isFavorite = Constant.favoriteList.firstWhereOrNull(
                            (element) =>
                                element.fixture.id == match.fixture.id) !=
                        null;
                  });
                }
              }

              if (state is FavoriteMatchRemoved) {
                if (state.footballMatches) {
                  setState(() {
                    isFavorite = Constant.favoriteList.firstWhereOrNull(
                            (element) =>
                                element.fixture.id == match.fixture.id) !=
                        null;
                  });
                }
              }
            },
          ),
        ],
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FootballMatchInfoPage(match: match),
            ));
          },
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      )),
                  height: match.events != null
                      ? MediaQuery.of(context).size.height * 0.11
                      : afterFiveMin
                          ? MediaQuery.of(context).size.height * 0.1
                          : widget.availableToBet != null &&
                                  widget.availableToBet!
                              ? MediaQuery.of(context).size.height * 0.15
                              : MediaQuery.of(context).size.height * 0.1,
                  child: Column(children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Expanded(
                          //   child: Text(
                          //     match.home.name,
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 16.0,
                          //     ),
                          //   ),
                          // ),
                          // Image.network(
                          //   match.home.logoUrl,
                          //   width: 36.0,
                          // ),
                          FootballHomeWidget(
                              team: match.home, gotEvents: false),

                          if (widget.isIncoming)
                            Expanded(
                              child: Text(
                                Constant.formattedTime(
                                    DateTime.parse(match.fixture.date)
                                        .toLocal()),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          if (!(widget.isIncoming))
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                (match.fixture.status.short == '1H' ||
                                        match.fixture.status.short == '2H' ||
                                        match.fixture.status.short == 'P' ||
                                        match.fixture.status.short == 'ET' ||
                                        match.fixture.status.short == 'BT' ||
                                        match.fixture.status.short == 'HT')
                                    ? Text(
                                        (match.fixture.status.elapsedTime != null
                                                ? match
                                                    .fixture.status.elapsedTime
                                                    .toString()
                                                : '') +
                                            (match.events !=
                                                        null &&
                                                    ((match.fixture.status.short ==
                                                                '1H' &&
                                                            match.fixture.status
                                                                    .elapsedTime ==
                                                                45) ||
                                                        (match.fixture.status
                                                                    .short ==
                                                                '2H' &&
                                                            match.fixture.status
                                                                    .elapsedTime ==
                                                                90))
                                                ? '+'
                                                : '') +
                                            (extraTime != 0
                                                ? extraTime.toString()
                                                : '') +
                                            (match.fixture.status.elapsedTime !=
                                                    null
                                                ? ' : '
                                                : '') +
                                            (extraTime != 0
                                                ? match.fixture.status.short!
                                                : match.fixture.status.long!),
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12.0,
                                        ),
                                      )
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                (match.fixture.status.short == 'CANC' ||
                                        match.fixture.status.short == 'ABD')
                                    ? AutoSizeText(
                                        match.fixture.status.long!,
                                        textAlign: TextAlign.center,
                                        wrapWords: false,
                                        minFontSize: 5,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      )
                                    : match.fixture.status.short != 'NS'
                                        ? Text(
                                            //                 "////${match.goal != null && match.goal!.home != null ? (homeEvent != null && match.goal!.home! > homeEvent!.map((e) => e.type.toLowerCase() == 'goal').length ? match.goal!.home! : homeEvent!.map((e) => e.type.toLowerCase() == 'goal').length) : '0'} - ${match.goal != null && match.goal!.away != null ? match.goal!.away : '0'}",

                                            "${match.goal != null && match.goal!.home != null ? (match.score != null && match.score!.penalty != null ? (match.goal!.home! + match.score!.penalty!.home!) : match.goal!.home) : '0'} - ${match.goal != null && match.goal!.away != null ? (match.score != null && match.score!.penalty != null ? (match.goal!.away! + match.score!.penalty!.away!) : match.goal!.away) : '0'}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                            ),
                                          )
                                        : Text(
                                            Constant.formattedTime(
                                                DateTime.parse(
                                                        match.fixture.date)
                                                    .toLocal()),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                            ),
                                          ),
                              ],
                            )),
                          FootballAwayWidget(
                            team: match.away,
                            gotEvents: false,
                          )
                          // Image.network(
                          //   match.away.logoUrl,
                          //   width: 36.0,
                          // ),
                          // Expanded(
                          //   child: Text(
                          //     match.away.name,
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 16.0,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // if (match.events != null)
                    //   Expanded(
                    //     flex: 1,
                    //     child: Row(
                    //       children: [
                    //         Expanded(
                    //             flex: 2,
                    //             child: FootballEventsText(
                    //               events: homeEvent,
                    //               isRight: false,
                    //             )),
                    //         Expanded(
                    //           flex: 1,
                    //           child: Container(),
                    //         ),
                    //         Expanded(
                    //             flex: 2,
                    //             child: FootballEventsText(
                    //               events: awayEvent,
                    //               isRight: true,
                    //             ))
                    //       ],
                    //     ),
                    //   ),
                    if (widget.isIncoming &&
                        widget.availableToBet != null &&
                        widget.availableToBet!)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Showcase(
                            key: _key1,
                            description:
                                "Users can bet on upcoming match to earn more coin for exchange prize, for more details can go to setting page read through bet guide",
                            // overlayPadding: EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  BetButton(
                                    predict: 'Home',
                                    match: match,
                                    bet: Constant.betList[0].firstWhereOrNull(
                                        (element) =>
                                            element.id == match.fixture.id),
                                    refresh: widget.refresh != null
                                        ? widget.refresh!
                                        : () {},
                                  ),
                                  BetButton(
                                    predict: 'Draw',
                                    match: match,
                                    bet: Constant.betList[0].firstWhereOrNull(
                                        (element) =>
                                            element.id == match.fixture.id),
                                    refresh: widget.refresh != null
                                        ? widget.refresh!
                                        : () {},
                                  ),
                                  BetButton(
                                    predict: 'Away',
                                    match: match,
                                    bet: Constant.betList[0].firstWhereOrNull(
                                        (element) =>
                                            element.id == match.fixture.id),
                                    refresh: widget.refresh != null
                                        ? widget.refresh!
                                        : () {},
                                  ),
                                ]),
                          ),
                        ),
                      )
                  ]),
                ),
                // if (matchOngoing || widget.isFavTab != null)
                //   Showcase(
                //     key: _key2,
                //     description:
                //         "Users also can favourite their match, which will be stored in favourite section",
                //     // overlayPadding: EdgeInsets.symmetric(vertical: 15),
                //     child: GestureDetector(
                //       onTap: () {
                //         setState(() {
                //           if (isFavorite) {
                //             _favoriteMatchBloc
                //                 .add(RemoveFavoriteMatchRequest(match: match));
                //           } else {
                //             _favoriteMatchBloc
                //                 .add(PersistFavoriteMatchRequest(match: match));
                //           }
                //         });
                //       },
                //       child: Container(
                //         padding: EdgeInsets.all(1),
                //         width: double.infinity,
                //         decoration: BoxDecoration(
                //             color: Colors.grey,
                //             borderRadius: new BorderRadius.only(
                //                 bottomLeft: const Radius.circular(20.0),
                //                 bottomRight: const Radius.circular(20.0))),
                //         child: Icon(
                //           isFavorite ? Icons.star : Icons.star_border_outlined,
                //           color: Colors.yellow,
                //         ),
                //       ),
                //     ),
                //   )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // refreshBet() {
  //   setState(() {
  //     print('got refesh bet ma ??');
  //     Constant.betList = Constant.betList;
  //   });
  // }
}
