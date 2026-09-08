// import 'dart:collection';
// import 'dart:convert';

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:collection/collection.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:showcaseview/showcaseview.dart';
// import 'package:soccer_sport/core/constant/constants.dart';
// import 'package:soccer_sport/core/widgets/loading_widget.dart';
// import 'package:soccer_sport/core/widgets/no_data_widget.dart';
// import 'package:soccer_sport/favorite_match/presentation/bloc/favorite_match_bloc.dart';
// import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
// import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
// import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
// import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_away_widget.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_events_text.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_home_widget.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_live_match_list_tile.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_match_league_seperator.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_match_no_live_data.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/match_info/football_match_info.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/statistics_button.dart';

// import '../../../core/constant/analytics_service.dart';
// import '../../../injection_container.dart';

// class FootballLiveMatch extends StatefulWidget {
//   @override
//   State<FootballLiveMatch> createState() => _FootballLiveMatchState();
// }

// class _FootballLiveMatchState extends State<FootballLiveMatch> {
//   late DatabaseReference database;
//   final dataSubject = BehaviorSubject<DatabaseEvent>();

//   List<FootballMatch> liveMatches = [];
//   final _key1 = GlobalKey();
//   bool navigateNewPage = false;
//   final _key3 = GlobalKey();
//   @override
//   void initState() {
//     database = FirebaseDatabase.instance.ref('62');
//     serviceLocator<AnalyticsService>()
//         .logScreens(name: '/footballMatchPage/live/match');
//     super.initState();

//     // WidgetsBinding.instance!.addPostFrameCallback((_) {
//     //   if (Constant.showcaseBool)
//     //     ShowCaseWidget.of(context).startShowCase([
//     //       _key1,
//     //       Constant.liveTodayKey,
//     //       Constant.matchTabKey,
//     //     ]);
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: database.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return LoadingWidget();
//           } else if (snapshot.hasData) {
//             print('has firebase data1');
//             DatabaseEvent data = snapshot.data as DatabaseEvent;

//             dataSubject.add(data);

//             if (data.snapshot.value != null) {
//               var jsonvalue = Map<String, dynamic>.from(
//                   data.snapshot.value as LinkedHashMap);
//               // print(jsonvalue);
//               if (jsonvalue.isNotEmpty) {
//                 print(jsonvalue.entries);
//                 liveMatches = jsonvalue.entries
//                     .map((entry) => FootballMatchModel.fromJson(
//                         jsonDecode(jsonEncode(entry.value))))
//                     .toList();
//               }
//             }

//             return

//                 // Showcase(
//                 //   key: _key1,
//                 //   description:
//                 //       "In live section, can see any league that currently on live.",
//                 //   child:

//                 liveMatches.length > 0
//                     ? Container(
//                         width: double.infinity,
//                         height: double.infinity,
//                         child: Padding(
//                           padding: EdgeInsets.zero,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: GroupedListView<FootballMatch, String>(
//                                     addAutomaticKeepAlives: false,
//                                     shrinkWrap: true,
//                                     order: GroupedListOrder.DESC,
//                                     sort: true,
//                                     itemComparator: (item1, item2) =>
//                                         DateTime.parse(item1.fixture.date)
//                                             .toLocal()
//                                             .compareTo(DateTime.parse(
//                                                     item2.fixture.date)
//                                                 .toLocal()),
//                                     elements: liveMatches,
//                                     groupBy: (match) => match.league!.id == 1
//                                         ? 'FIFA World Cup(tm)'
//                                         : match.league!.name,
//                                     groupSeparatorBuilder: (String league) =>
//                                         FootballMatchLeagueSeperator(
//                                           league: league,
//                                           matchs: liveMatches,
//                                         ),
//                                     indexedItemBuilder: (context,
//                                         FootballMatch match, int index) {
//                                       final FootballMatchBloc
//                                           _footballMatchBloc =
//                                           serviceLocator<FootballMatchBloc>();
//                                       final FavoriteMatchBloc
//                                           _favoriteMatchBloc =
//                                           serviceLocator<FavoriteMatchBloc>();
//                                       int extraTime = 0;

//                                       List<Event>? awayEvent;
//                                       List<Event>? homeEvent;
//                                       bool matchOngoing = false;
//                                       bool isFavorite = false;

//                                       if (match.events != null &&
//                                           match.events!.length > 0 &&
//                                           (match.fixture.status.short == '1H' &&
//                                                   match.fixture.status
//                                                           .elapsedTime ==
//                                                       45 ||
//                                               match.fixture.status.short ==
//                                                       '2H' &&
//                                                   match.fixture.status
//                                                           .elapsedTime ==
//                                                       90) &&
//                                           match.events!.last.time.extra !=
//                                               null) {
//                                         extraTime =
//                                             match.events!.last.time.extra!;
//                                       } else {
//                                         extraTime = 0;
//                                       }

//                                       if (match.events != null) {
//                                         awayEvent = match.events!
//                                             .where((element) =>
//                                                 element.team != null &&
//                                                 element.team!.id ==
//                                                     match.away.id)
//                                             .toList();
//                                         homeEvent = match.events!
//                                             .where((element) =>
//                                                 element.team != null &&
//                                                 element.team!.id ==
//                                                     match.home.id)
//                                             .toList();
//                                       }

//                                       matchOngoing = (match
//                                                   .fixture.status.short !=
//                                               'FT' &&
//                                           match.fixture.status.short != 'AET' &&
//                                           match.fixture.status.short != 'PEN');
//                                       isFavorite = Constant.favoriteList
//                                               .firstWhereOrNull((element) =>
//                                                   element.fixture.id ==
//                                                   match.fixture.id) !=
//                                           null;

//                                       return Container(
//                                         key: ValueKey(match.fixture.id),
//                                         child: MultiBlocProvider(
//                                           providers: [
//                                             BlocProvider(
//                                               create: (context) =>
//                                                   _footballMatchBloc,
//                                             ),
//                                             BlocProvider(
//                                               create: (context) =>
//                                                   _favoriteMatchBloc,
//                                             ),
//                                           ],
//                                           child: MultiBlocListener(
//                                             listeners: [
//                                               BlocListener<FootballMatchBloc,
//                                                   FootballMatchState>(
//                                                 listener: (context, state) {},
//                                               ),
//                                               BlocListener<FavoriteMatchBloc,
//                                                   FavoriteMatchState>(
//                                                 listener: (context, state) {
//                                                   if (state
//                                                       is FavoriteMatchPersisted) {
//                                                     if (state.footballMatches) {
//                                                       setState(() {
//                                                         isFavorite = Constant
//                                                                 .favoriteList
//                                                                 .firstWhereOrNull((element) =>
//                                                                     element
//                                                                         .fixture
//                                                                         .id ==
//                                                                     match
//                                                                         .fixture
//                                                                         .id) !=
//                                                             null;
//                                                       });
//                                                     }
//                                                   }

//                                                   if (state
//                                                       is FavoriteMatchRemoved) {
//                                                     if (state.footballMatches) {
//                                                       setState(() {
//                                                         isFavorite = Constant
//                                                                 .favoriteList
//                                                                 .firstWhereOrNull((element) =>
//                                                                     element
//                                                                         .fixture
//                                                                         .id ==
//                                                                     match
//                                                                         .fixture
//                                                                         .id) !=
//                                                             null;
//                                                       });
//                                                     }
//                                                   }
//                                                 },
//                                               ),
//                                             ],
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(5.0),
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.of(context)
//                                                       .push(MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         FootballMatchInfoPage(
//                                                       match: match,
//                                                       // dataSubject: dataSubject,
//                                                     ),
//                                                   ))
//                                                       .then((value) {
//                                                     setState(() {
//                                                       navigateNewPage = false;
//                                                     });
//                                                   });
//                                                 },
//                                                 child: Column(children: [
//                                                   Container(
//                                                     height: match.events != null
//                                                         ? MediaQuery.of(context)
//                                                                 .size
//                                                                 .height *
//                                                             0.12
//                                                         : MediaQuery.of(context)
//                                                                 .size
//                                                                 .height *
//                                                             0.1,
//                                                     decoration: BoxDecoration(
//                                                         color: Colors.white,
//                                                         borderRadius:
//                                                             new BorderRadius
//                                                                 .only(
//                                                           topLeft: const Radius
//                                                               .circular(20.0),
//                                                           topRight: const Radius
//                                                               .circular(20.0),
//                                                           bottomLeft:
//                                                               Radius.circular(
//                                                                   20.0),
//                                                           bottomRight:
//                                                               Radius.circular(
//                                                                   20.0),
//                                                         )),
//                                                     child: Column(children: [
//                                                       Expanded(
//                                                         flex: 2,
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             FootballHomeWidget(
//                                                               team: match.home,
//                                                               gotEvents: false,
//                                                             ),
//                                                             Expanded(
//                                                                 child: Column(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 SizedBox(
//                                                                   height: MediaQuery.of(
//                                                                               context)
//                                                                           .size
//                                                                           .height *
//                                                                       0.01,
//                                                                 ),
//                                                                 (match.fixture
//                                                                                 .status.short ==
//                                                                             '1H' ||
//                                                                         match.fixture.status.short ==
//                                                                             '2H' ||
//                                                                         match.fixture.status.short ==
//                                                                             'P' ||
//                                                                         match.fixture.status.short ==
//                                                                             'ET' ||
//                                                                         match.fixture.status.short ==
//                                                                             'BT' ||
//                                                                         match.fixture.status.short ==
//                                                                             'HT')
//                                                                     ? AutoSizeText(
//                                                                         (match.fixture.status.elapsedTime != null ? match.fixture.status.elapsedTime.toString() : '') +
//                                                                             (match.events != null && ((match.fixture.status.short == '1H' && match.fixture.status.elapsedTime == 45) || (match.fixture.status.short == '2H' && match.fixture.status.elapsedTime == 90))
//                                                                                 ? '+'
//                                                                                 : '') +
//                                                                             (extraTime != 0
//                                                                                 ? extraTime.toString()
//                                                                                 : '') +
//                                                                             (match.fixture.status.elapsedTime != null ? ' : ' : '') +
//                                                                             (extraTime != 0 ? match.fixture.status.short! : match.fixture.status.long!),
//                                                                         style:
//                                                                             TextStyle(
//                                                                           color:
//                                                                               Colors.green,
//                                                                         ),
//                                                                         wrapWords:
//                                                                             false,
//                                                                         maxFontSize:
//                                                                             12,
//                                                                         minFontSize:
//                                                                             8,
//                                                                       )
//                                                                     : SizedBox(
//                                                                         height: MediaQuery.of(context).size.height *
//                                                                             0.01,
//                                                                       ),
//                                                                 SizedBox(
//                                                                   height: MediaQuery.of(
//                                                                               context)
//                                                                           .size
//                                                                           .height *
//                                                                       0.02,
//                                                                 ),
//                                                                 (match.fixture.status.short ==
//                                                                             'CANC' ||
//                                                                         match.fixture.status.short ==
//                                                                             'ABD')
//                                                                     ? AutoSizeText(
//                                                                         match
//                                                                             .fixture
//                                                                             .status
//                                                                             .long!,
//                                                                         wrapWords:
//                                                                             true,
//                                                                         textAlign:
//                                                                             TextAlign.center,
//                                                                         minFontSize:
//                                                                             5,
//                                                                         style:
//                                                                             TextStyle(
//                                                                           color:
//                                                                               Colors.black,
//                                                                         ),
//                                                                       )
//                                                                     : match.fixture.status.short !=
//                                                                             'NS'
//                                                                         ? Text(
//                                                                             //                 "////${match.goal != null && match.goal!.home != null ? (homeEvent != null && match.goal!.home! > homeEvent!.map((e) => e.type.toLowerCase() == 'goal').length ? match.goal!.home! : homeEvent!.map((e) => e.type.toLowerCase() == 'goal').length) : '0'} - ${match.goal != null && match.goal!.away != null ? match.goal!.away : '0'}",

//                                                                             "${match.goal != null && match.goal!.home != null ? (match.score != null && match.score!.penalty != null ? (match.goal!.home! + match.score!.penalty!.home!) : match.goal!.home) : '0'} - ${match.goal != null && match.goal!.away != null ? (match.score != null && match.score!.penalty != null ? (match.goal!.away! + match.score!.penalty!.away!) : match.goal!.away) : '0'}",
//                                                                             textAlign:
//                                                                                 TextAlign.center,
//                                                                             style:
//                                                                                 TextStyle(
//                                                                               color: Colors.black,
//                                                                               fontSize: 16.0,
//                                                                             ),
//                                                                           )
//                                                                         : Text(
//                                                                             Constant.formattedTime(DateTime.parse(match.fixture.date).toLocal()),
//                                                                             textAlign:
//                                                                                 TextAlign.center,
//                                                                             style:
//                                                                                 TextStyle(
//                                                                               color: Colors.black,
//                                                                               fontSize: 16.0,
//                                                                             ),
//                                                                           )
//                                                               ],
//                                                             )),
//                                                             FootballAwayWidget(
//                                                               team: match.away,
//                                                               gotEvents: false,
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       if (match.events != null)
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               Expanded(
//                                                                   flex: 2,
//                                                                   child:
//                                                                       FootballEventsText(
//                                                                     events:
//                                                                         homeEvent,
//                                                                     isRight:
//                                                                         false,
//                                                                   )),
//                                                               Expanded(
//                                                                 flex: 1,
//                                                                 child:
//                                                                     Container(),
//                                                               ),
//                                                               Expanded(
//                                                                   flex: 2,
//                                                                   child:
//                                                                       FootballEventsText(
//                                                                     events:
//                                                                         awayEvent,
//                                                                     isRight:
//                                                                         true,
//                                                                   ))
//                                                             ],
//                                                           ),
//                                                         )
//                                                     ]),
//                                                   ),
//                                                   // if (matchOngoing)
//                                                   //   GestureDetector(
//                                                   //     onTap: () {
//                                                   //       setState(() {
//                                                   //         if (isFavorite) {
//                                                   //           _favoriteMatchBloc.add(
//                                                   //               RemoveFavoriteMatchRequest(
//                                                   //                   match:
//                                                   //                       match));
//                                                   //         } else {
//                                                   //           _favoriteMatchBloc.add(
//                                                   //               PersistFavoriteMatchRequest(
//                                                   //                   match:
//                                                   //                       match));
//                                                   //         }
//                                                   //       });
//                                                   //     },
//                                                   //     child: Container(
//                                                   //       padding:
//                                                   //           EdgeInsets.all(1),
//                                                   //       width: double.infinity,
//                                                   //       decoration: BoxDecoration(
//                                                   //           color: Colors.grey,
//                                                   //           borderRadius: new BorderRadius
//                                                   //                   .only(
//                                                   //               bottomLeft:
//                                                   //                   const Radius
//                                                   //                           .circular(
//                                                   //                       20.0),
//                                                   //               bottomRight:
//                                                   //                   const Radius
//                                                   //                           .circular(
//                                                   //                       20.0))),
//                                                   //       child: Icon(
//                                                   //         isFavorite
//                                                   //             ? Icons.star
//                                                   //             : Icons
//                                                   //                 .star_border_outlined,
//                                                   //         color: Colors.yellow,
//                                                   //       ),
//                                                   //     ),
//                                                   //   )
//                                                 ]),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       );

//                                       return FootballMatchLiveListTile(
//                                         footballMatch: match,
//                                       );
//                                     }),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     : Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                             FootballMatchNoLiveData(),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             StatisticsButton(),
//                           ]);
//             // );
//           } else {
//             return NoDataWidget();
//           }
//         });
//   }
// }
