import 'dart:collection';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_incoming_live_match.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_live_match_list.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_league_seperator.dart';

import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../favorite_match/presentation/bloc/favorite_match_bloc.dart';
import '../../../injection_container.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/live_match/live_match.dart';
import '../bloc/football_match_bloc.dart';
import 'football_away_widget.dart';
import 'football_events_text.dart';
import 'football_home_widget.dart';
import 'match_info/football_match_info.dart';

class FootballLiveMatchTab extends StatefulWidget {
  FootballLiveMatchTab({Key? key}) : super(key: key);

  @override
  State<FootballLiveMatchTab> createState() => _FootballLiveMatchTabState();
}

class _FootballLiveMatchTabState extends State<FootballLiveMatchTab>
    with SingleTickerProviderStateMixin {
  final _key2 = GlobalKey();
  bool matchOngoing = false;
  List<FootballMatch> footballMatches = [];
  List<FootballMatch> comingSoonMatches = [];
  List<FootballMatch> resultMatch = [];
  bool openAppForFirstTime = true;

  final FavoriteMatchBloc _favoriteMatchBloc =
      serviceLocator<FavoriteMatchBloc>();
  DatabaseReference? database;
  TabController? _tabController;

  // List<LiveMatch> concludedMatches = [];

  List<FootballMatch>? liveMatches;
  int test = 0;

  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();

  @override
  void initState() {
    database = FirebaseDatabase.instance.ref('62');

    _footballMatchBloc.add(GetIncomingLiveMatchRequest());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<FootballMatchBloc>(
              create: (_) => _footballMatchBloc,
            ),
            BlocProvider(
              create: (context) => _favoriteMatchBloc,
            ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<FootballMatchBloc, FootballMatchState>(
                listener: (context, state) {
                  if (state is IncomingLiveMatchLoaded) {
                    setState(() {
                      footballMatches = state.footballMatches!;
                      comingSoonMatches = footballMatches
                          .where((element) =>
                              element.fixture.status.short == "NS" ||
                              element.fixture.status.short == "NS" ||
                              element.fixture.status.short == "PST" ||
                              element.fixture.status.short == "CANC" ||
                              element.fixture.status.short == "ABD")
                          .toList();

                      resultMatch = footballMatches
                          .where((element) =>
                              element.fixture.status.short == "FT" ||
                              element.fixture.status.short == "AET" ||
                              element.fixture.status.short == "PEN")
                          .toList();
                      // footballMatches.forEach((element) {
                      //   LiveMatch? hasContain =
                      //       concludedMatches.firstWhereOrNull((match) =>
                      //           element.league!.name == match.league);
                      //   if (hasContain != null) {
                      //     int index = concludedMatches.indexOf(hasContain);
                      //     concludedMatches[index].footballMatch.add(element);
                      //   } else {
                      //     concludedMatches.add(LiveMatch(
                      //         league: element.league!.name,
                      //         footballMatch: [element],
                      //         live: liveMatches != null
                      //             ? liveMatches!.firstWhereOrNull((live) {
                      //                   return live.league!.name ==
                      //                       element.league!.name;
                      //                 }) !=
                      //                 null
                      //             : false));
                      //   }
                      // });

                      _tabController = new TabController(
                        vsync: this,
                        length: 3,
                      );
                    });
                  }
                },
              ),
              BlocListener<FavoriteMatchBloc, FavoriteMatchState>(
                listener: (context, state) {
                  if (state is FavoriteMatchPersisted) {
                    if (state.footballMatches) {
                      setState(() {
                        Constant.favoriteList = Constant.favoriteList;
                      });
                    }
                  }

                  if (state is FavoriteMatchRemoved) {
                    if (state.footballMatches) {
                      setState(() {
                        Constant.favoriteList = Constant.favoriteList;
                      });
                    }
                  }
                },
              ),
            ],
            child: StreamBuilder(
                stream: database != null ? database!.onValue : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingWidget();
                  } else if (snapshot.hasData) {
                    DatabaseEvent data = snapshot.data as DatabaseEvent;
                    if (data.snapshot.value != null) {
                      var jsonvalue = Map<String, dynamic>.from(
                          data.snapshot.value as LinkedHashMap);
                      // print(jsonvalue);
                      if (jsonvalue.isNotEmpty) {
                        liveMatches = jsonvalue.entries
                            .map((entry) => FootballMatchModel.fromJson(
                                jsonDecode(jsonEncode(entry.value))))
                            .toList();
                        Constant.liveData
                            .add(liveMatches != null ? liveMatches! : []);
                        if (liveMatches != null &&
                            liveMatches!.length > 0 &&
                            openAppForFirstTime &&
                            _tabController != null) {
                          _tabController!.animateTo(1);
                          openAppForFirstTime = false;
                        }
                      }
                    }

                    return Container(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: BlocBuilder(
                            bloc: _footballMatchBloc,
                            builder: (context, state) {
                              if (state is LoadIncomingLiveMatch) {
                                return LoadingWidget();
                              } else if (state is FootballMatchesError) {
                                return ErrorsWidget();
                              } else {
                                if (footballMatches.length > 0) {
                                  if (liveMatches != null) {
                                    // concludedMatches.sort((a, b) {
                                    //   bool aHasLiveMatch = liveMatches!.any(
                                    //       (match) =>
                                    //           a.league ==
                                    //           (match.league!.id == 1
                                    //               ? 'FIFA World Cup(tm)'
                                    //               : match.league!.name));
                                    //   // bool bHasLiveMatch = b['items'].any((item) => item['live']);
                                    //   bool bHasLiveMatch = liveMatches!.any(
                                    //       (match) =>
                                    //           b.league ==
                                    //           (match.league!.id == 1
                                    //               ? 'FIFA World Cup(tm)'
                                    //               : match.league!.name));

                                    //   if (aHasLiveMatch && !bHasLiveMatch) {
                                    //     return 1;
                                    //   } else if (!aHasLiveMatch &&
                                    //       bHasLiveMatch) {
                                    //     return -1;
                                    //   } else {
                                    //     return 0;
                                    //   }
                                    // });
                                  }

                                  return Container(
                                    height: double.infinity,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors
                                                    .white, // Set the color of the indicator line here
                                                width:
                                                    1.0, // Customize the width of the indicator line
                                              ),
                                            ),
                                          ),
                                          width: double.infinity,
                                          child: TabBar(
                                              controller: _tabController,
                                              indicator: BoxDecoration(
                                                  // Customize the indicator using BoxDecoration
                                                  border: null
                                                  // Border(
                                                  //   bottom: BorderSide(
                                                  //     color: Colors
                                                  //         .yellow, // Set the color of the indicator line here
                                                  //     width:
                                                  //         2.0, // Customize the width of the indicator line
                                                  //   ),
                                                  // ),
                                                  ),
                                              labelColor: Colors
                                                  .yellow, // Customize the selected tab's text color
                                              unselectedLabelColor: Colors.grey,
                                              tabs: [
                                                Tab(
                                                  text: "Result",
                                                ),
                                                Tab(text: "Live"),
                                                Tab(
                                                  text: "Upcoming",
                                                ),
                                              ]),
                                        ),
                                        Expanded(
                                          child: TabBarView(
                                            controller: _tabController,
                                            children: [
                                              groupListView(resultMatch),
                                              groupListView(liveMatches),
                                              groupListView(comingSoonMatches),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  return NoDataWidget();
                                }
                              }
                            }),
                      ),
                    );
                  } else {
                    return NoDataWidget();
                  }
                }),
          ),
        ));
  }

  Widget groupListView(List<FootballMatch>? list) {
    return list != null
        ? GroupedListView<FootballMatch, String>(
            addAutomaticKeepAlives: false,
            shrinkWrap: true,
            elements: list,
            order: GroupedListOrder.DESC,
            sort: true,
            // groupComparator: (value1, value2) {
            //   if (liveMatches != null) {
            //     FootballMatch? firstLive =
            //         liveMatches!.firstWhereOrNull(
            //             (match) =>
            //                 value1 ==
            //                 (match.league!.id == 1
            //                     ? 'FIFA World Cup(tm)'
            //                     : match
            //                         .league!.name));
            //     FootballMatch? secondLive =
            //         liveMatches!.firstWhereOrNull(
            //             (match) =>
            //                 value2 ==
            //                 (match.league!.id == 1
            //                     ? 'FIFA World Cup(tm)'
            //                     : match
            //                         .league!.name));
            //     if (firstLive != null &&
            //         secondLive != null) {
            //       return 0;
            //     } else if (firstLive != null &&
            //         secondLive == null) {
            //       return 1;
            //     } else if (firstLive == null &&
            //         secondLive != null) {
            //       return -1;
            //     } else {
            //       return -1;
            //     }
            //   } else {
            //     return value1.compareTo(value2);
            //   }
            // },
            groupBy: (match) => match.league!.id == 1
                ? 'FIFA World Cup(tm)'
                : match.league!.name,
            groupSeparatorBuilder: (String league) =>
                FootballMatchLeagueSeperator(
                  league: league,
                  matchs: footballMatches,
                ),
            indexedItemBuilder:
                (context, FootballMatch footballMatch, int index) {
              bool isLive = false;
              bool matchOngoing = false;
              FootballMatch match = footballMatch;
              if (liveMatches != null) {
                FootballMatch? onLive = liveMatches!.firstWhereOrNull(
                    (element) => element.fixture.id == match.fixture.id);
                if (onLive != null) {
                  match = onLive;
                  isLive = true;
                }
              }

              int extraTime = 0;
              List<Event>? awayEvent;
              List<Event>? homeEvent;
              bool isFavorite = Constant.favoriteList.firstWhereOrNull(
                      (element) => element.fixture.id == match.fixture.id) !=
                  null;

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
                        element.team != null &&
                        element.team!.id == match.away.id)
                    .toList();
                homeEvent = match.events!
                    .where((element) =>
                        element.team != null &&
                        element.team!.id == match.home.id)
                    .toList();
              }

              matchOngoing = (match.fixture.status.short != 'FT' &&
                  match.fixture.status.short != 'AET' &&
                  match.fixture.status.short != 'PEN');
              isFavorite = Constant.favoriteList.firstWhereOrNull(
                      (element) => element.fixture.id == match.fixture.id) !=
                  null;

              // return FootballMatchLiveListTile(
              //   footballMatch: match,
              // );
              return Container(
                key: ValueKey(match),
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              FootballMatchInfoPage(match: match)),
                    );
                  },
                  child: Stack(
                    children: [
                      Column(children: [
                        Container(
                          height: match.events != null
                              ? MediaQuery.of(context).size.height * 0.11
                              : MediaQuery.of(context).size.height * 0.11,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              )),
                          child: Column(children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FootballHomeWidget(
                                    team: match.home,
                                    gotEvents: false,
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      (match.fixture.status.short == '1H' ||
                                              match.fixture.status.short ==
                                                  '2H' ||
                                              match.fixture.status.short ==
                                                  'P' ||
                                              match.fixture.status.short ==
                                                  'ET' ||
                                              match.fixture.status.short ==
                                                  'BT' ||
                                              match.fixture.status.short ==
                                                  'HT')
                                          ? Text(
                                              (match.fixture.status.elapsedTime != null
                                                      ? match.fixture.status.elapsedTime
                                                          .toString()
                                                      : '') +
                                                  (match.events != null &&
                                                          ((match.fixture.status.short ==
                                                                      '1H' &&
                                                                  match.fixture.status
                                                                          .elapsedTime ==
                                                                      45) ||
                                                              (match.fixture.status
                                                                          .short ==
                                                                      '2H' &&
                                                                  match.fixture
                                                                          .status.elapsedTime ==
                                                                      90))
                                                      ? '+'
                                                      : '') +
                                                  (extraTime != 0
                                                      ? extraTime.toString()
                                                      : '') +
                                                  (match.fixture.status.elapsedTime != null
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
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      (match.fixture.status.short == 'CANC' ||
                                              match.fixture.status.short ==
                                                  'ABD')
                                          ? AutoSizeText(
                                              match.fixture.status.long!,
                                              wrapWords: false,
                                              textAlign: TextAlign.center,
                                              minFontSize: 5,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            )
                                          : match.fixture.status.short != 'NS'
                                              ? Text(
                                                  //                 "////////////${match.goal != null && match.goal!.home != null ? (homeEvent != null && match.goal!.home! > homeEvent!.map((e) => e.type.toLowerCase() == 'goal').length ? match.goal!.home! : homeEvent!.map((e) => e.type.toLowerCase() == 'goal').length) : '0'} - ${match.goal != null && match.goal!.away != null ? match.goal!.away : '0'}",

                                                  "${match.goal != null && match.goal!.home != null ? (match.score != null && match.score!.penalty != null ? (match.goal!.home! + match.score!.penalty!.home!) : match.goal!.home) : '0'} - ${match.goal != null && match.goal!.away != null ? (match.score != null && match.score!.penalty != null ? (match.goal!.away! + match.score!.penalty!.away!) : match.goal!.away) : '0'}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                  ),
                                                )
                                              : Text(
                                                  Constant.formattedTime(
                                                      DateTime.parse(match
                                                              .fixture.date)
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
                            //   )
                          ]),
                        ),
                        // if (matchOngoing)
                        //   GestureDetector(
                        //     onTap: () {
                        //       setState(() {
                        //         if (isFavorite) {
                        //           _favoriteMatchBloc.add(
                        //               RemoveFavoriteMatchRequest(match: match));
                        //         } else {
                        //           _favoriteMatchBloc.add(
                        //               PersistFavoriteMatchRequest(match: match));
                        //         }
                        //       });
                        //     },
                        //     child: Container(
                        //       padding: EdgeInsets.all(1),
                        //       width: double.infinity,
                        //       decoration: BoxDecoration(
                        //           color: Colors.grey,
                        //           borderRadius: new BorderRadius.only(
                        //               bottomLeft: const Radius.circular(20.0),
                        //               bottomRight: const Radius.circular(20.0))
                        //               ),
                        //       child: Icon(
                        //         isFavorite
                        //             ? Icons.star
                        //             : Icons.star_border_outlined,
                        //         color: Colors.yellow,
                        //       ),
                        //     ),
                        //   )
                      ]),
                      if (isLive)
                        Positioned(
                            right: 5,
                            top: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Constant.color1,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Text("Ongoing",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  768
                                              ? 15
                                              : 7,
                                      fontWeight: FontWeight.bold)),
                            ))
                    ],
                  ),
                ),
              );
            })
        : Center(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.circleExclamation,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Currently no live match, go to 'Result' or 'Coming' to view today matches!",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
  }
}
