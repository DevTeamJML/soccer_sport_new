import 'dart:collection';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/favorite_match/presentation/bloc/favorite_match_bloc.dart';
import 'package:soccer_sport/favourite/presentation/widget/favourite_match_no_data.dart';
import 'package:soccer_sport/favourite/presentation/widget/navigate_match_page_button.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_date_seperator.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_list_tile.dart';

import '../../../footballMatch/data/model/football_match_model.dart';
import '../../../footballMatch/domain/entities/event.dart';
import '../../../footballMatch/presentation/bloc/football_match_bloc.dart';
import '../../../footballMatch/presentation/widget/football_away_widget.dart';
import '../../../footballMatch/presentation/widget/football_home_widget.dart';
import '../../../footballMatch/presentation/widget/match_info/football_match_info.dart';
import '../../../injection_container.dart';

class FavouriteMatchTab extends StatefulWidget {
  FavouriteMatchTab({Key? key}) : super(key: key);

  @override
  State<FavouriteMatchTab> createState() => _FavouriteMatchTabState();
}

class _FavouriteMatchTabState extends State<FavouriteMatchTab> {
  late DatabaseReference database;

  List<FootballMatch> favouriteList = [];
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();
  final FavoriteMatchBloc _favoriteMatchBloc =
      serviceLocator<FavoriteMatchBloc>();
  List<FootballMatch> lives = [];

  int? first;
  int? last;
  List<String> ids = [];
  final _key1 = GlobalKey();

  @override
  void initState() {
    super.initState();
    favouriteList = Constant.favoriteList;
    DateTime now = DateTime.now();
    database = FirebaseDatabase.instance.ref('62');

    ids = favouriteList
        .where((e) {
          DateTime start = DateTime.parse(e.fixture.date);
          DateTime end = start.add(Duration(minutes: 150));
          return ((e.fixture.status.short != "FT" &&
                  e.fixture.status.short != "AET" &&
                  e.fixture.status.short != "PEN" &&
                  e.fixture.status.short != "FT")) ||
              ((now.isAfter(start) || now.isAtSameMomentAs(start)) &&
                  (now.isBefore(end) || now.isAtSameMomentAs(end)));
        })
        .map((e) => e.fixture.id.toString())
        .toList();
    if (ids.length > 0) {
      _footballMatchBloc.add(GetFixtureBetweenDatesRequest(ids: ids));
    }
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   if (Constant.showcaseBool)
    //     ShowCaseWidget.of(context).startShowCase([
    //       _key1,
    //       Constant.favouriteTeamKey,
    //     ]);
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _footballMatchBloc.close();
    _favoriteMatchBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    if (favouriteList.length > 0) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<FootballMatchBloc>(
            create: (_) => _footballMatchBloc,
          ),
          BlocProvider<FavoriteMatchBloc>(
            create: (context) => _favoriteMatchBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<FootballMatchBloc, FootballMatchState>(
              listener: (context, state) {
                if (state is GetFixtureBetweenDatesLoaded) {
                  if (state.footballMatches != null) {
                    setState(() {
                      List<FootballMatch> updatedList = favouriteList.map((e) {
                        FootballMatch? updatedMatch = state.footballMatches!
                            .firstWhereOrNull(
                                (x) => x.fixture.id == e.fixture.id);
                        if (updatedMatch != null) {
                          return updatedMatch;
                        } else {
                          return e;
                        }
                      }).toList();
                      favouriteList = updatedList;
                      _favoriteMatchBloc.add(PersistUpdateFavoriteMatchRequest(
                          match: updatedList));
                    });
                  }
                }
              },
            ),
            BlocListener<FavoriteMatchBloc, FavoriteMatchState>(
              listener: (context, state) {
                if (state is UpdateFavoriteMatchPersisted) {
                  setState(() {
                    favouriteList = Constant.favoriteList;
                  });
                }
              },
            ),
          ],
          child: ids.length > 0
              ? BlocBuilder<FootballMatchBloc, FootballMatchState>(
                  builder: (context, state) {
                    if (state is LoadGetFixtureBetweenDates) {
                      return LoadingWidget();
                    } else if (state is FootballMatchesError) {
                      return ErrorWidget(state.message);
                    } else {
                      return BlocBuilder<FavoriteMatchBloc, FavoriteMatchState>(
                        builder: (context, state) {
                          if (state is PersistingUpdateFavoriteMatch) {
                            return LoadingWidget();
                          } else if (state is FavoriteMatchError) {
                            return ErrorWidget(state.message);
                          } else {
                            return StreamBuilder(
                                stream: database.onValue,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return LoadingWidget();
                                  } else if (snapshot.hasData) {
                                    DatabaseEvent data =
                                        snapshot.data as DatabaseEvent;
                                    if (data.snapshot.value != null) {
                                      var jsonvalue = Map<String, dynamic>.from(
                                          data.snapshot.value as LinkedHashMap);
                                      // print(jsonvalue);
                                      if (jsonvalue.isNotEmpty) {
                                        lives = jsonvalue.entries
                                            .map((entry) => FootballMatchModel
                                                .fromJson(jsonDecode(
                                                    jsonEncode(entry.value))))
                                            .toList();

                                        Constant.liveData.add(lives);
                                      }
                                    }
                                  }
                                  return Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child:
                                                GroupedListView<FootballMatch,
                                                        String>(
                                                    addAutomaticKeepAlives:
                                                        false,
                                                    shrinkWrap: true,
                                                    order:
                                                        GroupedListOrder.DESC,
                                                    sort: true,
                                                    itemComparator: (item1, item2) =>
                                                        DateTime.parse(item1.fixture.date)
                                                            .toLocal()
                                                            .compareTo(DateTime.parse(item2.fixture.date)
                                                                .toLocal()),
                                                    elements: favouriteList,
                                                    groupBy: (match) =>
                                                        Constant.formattedDate(
                                                            (DateTime.parse(match.fixture.date)
                                                                .toLocal())),
                                                    groupSeparatorBuilder:
                                                        (String date) =>
                                                            FootballMatchDateSeperator(
                                                              date: date,
                                                            ),
                                                    indexedItemBuilder: (context,
                                                        FootballMatch builderMatch,
                                                        int index) {
                                                      FootballMatch?
                                                          isLiveMatch = lives
                                                              .firstWhereOrNull(
                                                        (element) =>
                                                            element
                                                                .fixture.id ==
                                                            builderMatch
                                                                .fixture.id,
                                                      );
                                                      FootballMatch match =
                                                          isLiveMatch != null
                                                              ? isLiveMatch
                                                              : builderMatch;
                                                      bool isLive = false;
                                                      bool matchOngoing = false;

                                                      int extraTime = 0;
                                                      List<Event>? awayEvent;
                                                      List<Event>? homeEvent;
                                                      bool isFavorite = Constant
                                                              .favoriteList
                                                              .firstWhereOrNull(
                                                                  (element) =>
                                                                      element
                                                                          .fixture
                                                                          .id ==
                                                                      match
                                                                          .fixture
                                                                          .id) !=
                                                          null;

                                                      if (match.events !=
                                                              null &&
                                                          match.events!.length >
                                                              0 &&
                                                          (match.fixture.status
                                                                          .short ==
                                                                      '1H' &&
                                                                  match
                                                                          .fixture
                                                                          .status
                                                                          .elapsedTime ==
                                                                      45 ||
                                                              match.fixture.status
                                                                          .short ==
                                                                      '2H' &&
                                                                  match
                                                                          .fixture
                                                                          .status
                                                                          .elapsedTime ==
                                                                      90) &&
                                                          match.events!.last
                                                                  .time.extra !=
                                                              null) {
                                                        extraTime = match
                                                            .events!
                                                            .last
                                                            .time
                                                            .extra!;
                                                      } else {
                                                        extraTime = 0;
                                                      }

                                                      if (match.events !=
                                                          null) {
                                                        awayEvent = match
                                                            .events!
                                                            .where((element) =>
                                                                element.team !=
                                                                    null &&
                                                                element.team!
                                                                        .id ==
                                                                    match.away
                                                                        .id)
                                                            .toList();
                                                        homeEvent = match
                                                            .events!
                                                            .where((element) =>
                                                                element.team !=
                                                                    null &&
                                                                element.team!
                                                                        .id ==
                                                                    match.home
                                                                        .id)
                                                            .toList();
                                                      }

                                                      matchOngoing = (match
                                                                  .fixture
                                                                  .status
                                                                  .short !=
                                                              'FT' &&
                                                          match.fixture.status
                                                                  .short !=
                                                              'AET' &&
                                                          match.fixture.status
                                                                  .short !=
                                                              'PEN');
                                                      isFavorite = Constant
                                                              .favoriteList
                                                              .firstWhereOrNull(
                                                                  (element) =>
                                                                      element
                                                                          .fixture
                                                                          .id ==
                                                                      match
                                                                          .fixture
                                                                          .id) !=
                                                          null;

                                                      // return FootballMatchLiveListTile(
                                                      //   footballMatch: match,
                                                      // );
                                                      return Container(
                                                        key: ValueKey(match),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          FootballMatchInfoPage(
                                                                              match: match)),
                                                                )
                                                                .then((value) =>
                                                                    setState(
                                                                        () {
                                                                      favouriteList =
                                                                          Constant
                                                                              .favoriteList;
                                                                    }));
                                                          },
                                                          child: Stack(
                                                            children: [
                                                              Column(children: [
                                                                Container(
                                                                  height: match
                                                                              .events !=
                                                                          null
                                                                      ? MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.11
                                                                      : MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.11,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius:
                                                                              new BorderRadius.only(
                                                                            topLeft:
                                                                                const Radius.circular(20.0),
                                                                            topRight:
                                                                                const Radius.circular(20.0),
                                                                            bottomLeft:
                                                                                Radius.circular(20.0),
                                                                            bottomRight:
                                                                                Radius.circular(20.0),
                                                                          )),
                                                                  child: Column(
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
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
                                                                                    height: MediaQuery.of(context).size.height * 0.01,
                                                                                  ),
                                                                                  (match.fixture.status.short == '1H' || match.fixture.status.short == '2H' || match.fixture.status.short == 'P' || match.fixture.status.short == 'ET' || match.fixture.status.short == 'BT' || match.fixture.status.short == 'HT')
                                                                                      ? Text(
                                                                                          (match.fixture.status.elapsedTime != null ? match.fixture.status.elapsedTime.toString() : '') + (match.events != null && ((match.fixture.status.short == '1H' && match.fixture.status.elapsedTime == 45) || (match.fixture.status.short == '2H' && match.fixture.status.elapsedTime == 90)) ? '+' : '') + (extraTime != 0 ? extraTime.toString() : '') + (match.fixture.status.elapsedTime != null ? ' : ' : '') + (extraTime != 0 ? match.fixture.status.short! : match.fixture.status.long!),
                                                                                          style: TextStyle(
                                                                                            color: Colors.green,
                                                                                            fontSize: 12.0,
                                                                                          ),
                                                                                        )
                                                                                      : SizedBox(
                                                                                          height: MediaQuery.of(context).size.height * 0.01,
                                                                                        ),
                                                                                  SizedBox(
                                                                                    height: MediaQuery.of(context).size.height * 0.02,
                                                                                  ),
                                                                                  (match.fixture.status.short == 'CANC' || match.fixture.status.short == 'ABD')
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
                                                                                              Constant.formattedTime(DateTime.parse(match.fixture.date).toLocal()),
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
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Constant
                                                                            .color1,
                                                                        borderRadius:
                                                                            BorderRadius.circular(15.0),
                                                                      ),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      child: Text(
                                                                          "Ongoing",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: MediaQuery.of(context).size.width > 768 ? 15 : 7,
                                                                              fontWeight: FontWeight.bold)),
                                                                    ))
                                                            ],
                                                          ),
                                                        ),
                                                      );

                                                      //  FootballMatchListTile(
                                                      //   key: ValueKey(matchListTile.fixture.id),
                                                      //   footballMatch: matchListTile,
                                                      //   isIncoming: false,
                                                      //   live: false,
                                                      //   isFavTab: true,
                                                      // );
                                                    }),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                      );
                    }
                  },
                )
              : favouriteMatchContent(),
        ),
      );

      // StreamBuilder(
      //     stream: database.onValue,
      //     builder: (context, snapshot) {
      //       print('matchtab ruin ');
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return LoadingWidget();
      //       } else if (snapshot.hasData) {
      //         DatabaseEvent data = snapshot.data as DatabaseEvent;
      //         if (data.snapshot.value != null) {
      //           var jsonvalue = Map<String, dynamic>.from(
      //               data.snapshot.value as LinkedHashMap);
      //           // print(jsonvalue);
      //           if (jsonvalue.isNotEmpty) {
      //             lives = jsonvalue.entries
      //                 .map((entry) => FootballMatchModel.fromJson(
      //                     jsonDecode(jsonEncode(entry.value))))
      //                 .toList();
      //           }
      //         }
      //       }
      //       return
      //     });
    } else {
      return

          // Showcase(
          //   key: _key1,
          //   description:
          //       "The favourited matches that we mentioned before will be at here.",
          //   child:

          Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FavouriteMatchNoData(),
          SizedBox(
            height: 10,
          ),
          NavigateMatchPageButton(),
        ],
        // ),
      );
    }
  }

  Widget favouriteMatchContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GroupedListView<FootballMatch, String>(
                  addAutomaticKeepAlives: false,
                  shrinkWrap: true,
                  order: GroupedListOrder.DESC,
                  sort: true,
                  itemComparator: (item1, item2) =>
                      DateTime.parse(item1.fixture.date).toLocal().compareTo(
                          DateTime.parse(item2.fixture.date).toLocal()),
                  elements: favouriteList,
                  groupBy: (match) => Constant.formattedDate(
                      (DateTime.parse(match.fixture.date).toLocal())),
                  groupSeparatorBuilder: (String date) =>
                      FootballMatchDateSeperator(
                        date: date,
                      ),
                  indexedItemBuilder:
                      (context, FootballMatch builderMatch, int index) {
                    FootballMatch? isLiveMatch = lives.firstWhereOrNull(
                      (element) =>
                          element.fixture.id == builderMatch.fixture.id,
                    );
                    FootballMatch match =
                        isLiveMatch != null ? isLiveMatch : builderMatch;
                    bool isLive = false;
                    bool matchOngoing = false;

                    int extraTime = 0;
                    List<Event>? awayEvent;
                    List<Event>? homeEvent;
                    bool isFavorite = Constant.favoriteList.firstWhereOrNull(
                            (element) =>
                                element.fixture.id == match.fixture.id) !=
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
                            (element) =>
                                element.fixture.id == match.fixture.id) !=
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FootballHomeWidget(
                                          team: match.home,
                                          gotEvents: false,
                                        ),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                            (match.fixture.status.short ==
                                                        '1H' ||
                                                    match.fixture.status
                                                            .short ==
                                                        '2H' ||
                                                    match.fixture.status
                                                            .short ==
                                                        'P' ||
                                                    match.fixture.status
                                                            .short ==
                                                        'ET' ||
                                                    match.fixture.status
                                                            .short ==
                                                        'BT' ||
                                                    match.fixture.status
                                                            .short ==
                                                        'HT')
                                                ? Text(
                                                    (match.fixture.status.elapsedTime != null
                                                            ? match.fixture.status
                                                                .elapsedTime
                                                                .toString()
                                                            : '') +
                                                        (match.events != null &&
                                                                ((match.fixture.status.short == '1H' &&
                                                                        match.fixture.status.elapsedTime ==
                                                                            45) ||
                                                                    (match.fixture.status.short == '2H' &&
                                                                        match.fixture.status.elapsedTime ==
                                                                            90))
                                                            ? '+'
                                                            : '') +
                                                        (extraTime != 0
                                                            ? extraTime
                                                                .toString()
                                                            : '') +
                                                        (match.fixture.status
                                                                    .elapsedTime !=
                                                                null
                                                            ? ' : '
                                                            : '') +
                                                        (extraTime != 0
                                                            ? match.fixture
                                                                .status.short!
                                                            : match.fixture
                                                                .status.long!),
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 12.0,
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                  ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                            (match.fixture.status.short ==
                                                        'CANC' ||
                                                    match.fixture.status
                                                            .short ==
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
                                                : match.fixture.status.short !=
                                                        'NS'
                                                    ? Text(
                                                        //                 "////////////${match.goal != null && match.goal!.home != null ? (homeEvent != null && match.goal!.home! > homeEvent!.map((e) => e.type.toLowerCase() == 'goal').length ? match.goal!.home! : homeEvent!.map((e) => e.type.toLowerCase() == 'goal').length) : '0'} - ${match.goal != null && match.goal!.away != null ? match.goal!.away : '0'}",

                                                        "${match.goal != null && match.goal!.home != null ? (match.score != null && match.score!.penalty != null ? (match.goal!.home! + match.score!.penalty!.home!) : match.goal!.home) : '0'} - ${match.goal != null && match.goal!.away != null ? (match.score != null && match.score!.penalty != null ? (match.goal!.away! + match.score!.penalty!.away!) : match.goal!.away) : '0'}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.0,
                                                        ),
                                                      )
                                                    : Text(
                                                        Constant.formattedTime(
                                                            DateTime.parse(match
                                                                    .fixture
                                                                    .date)
                                                                .toLocal()),
                                                        textAlign:
                                                            TextAlign.center,
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
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    768
                                                ? 15
                                                : 7,
                                            fontWeight: FontWeight.bold)),
                                  ))
                          ],
                        ),
                      ),
                    );

                    //  FootballMatchListTile(
                    //   key: ValueKey(matchListTile.fixture.id),
                    //   footballMatch: matchListTile,
                    //   isIncoming: false,
                    //   live: false,
                    //   isFavTab: true,
                    // );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
