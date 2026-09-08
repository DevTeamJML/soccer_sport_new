import 'dart:collection';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/entities/matches_by_date.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/bet_list.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_away_widget.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_events_text.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_home_widget.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_incoming_match_list.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_list%20copy.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_list.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_no_live_data.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/match_info/football_match_info.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';

import '../../../core/constant/analytics_service.dart';
import '../../../injection_container.dart';
import '../bloc/football_match_bloc.dart';

class FootballMatchTabBarView extends StatefulWidget {
  final LeagueDetails league;

  const FootballMatchTabBarView({required this.league});

  @override
  State<FootballMatchTabBarView> createState() =>
      _FootballMatchTabBarViewState();
}

class _FootballMatchTabBarViewState extends State<FootballMatchTabBarView>
    with SingleTickerProviderStateMixin
// with AutomaticKeepAliveClientMixin<FootballMatchTabBarView>
{
  late TabController _tabController;
  List<int> availableBets = [39, 61, 78, 140];
  final GlobalKey _tabKey = GlobalKey();
  List<DateTime> dateList = [];
  List<FootballMatch> cloneList = [];

  List<FootballMatch>? footballMatches;
  List<FootballMatch>? liveMatches;
  DatabaseReference? database;

  List<MatchByDate> matchesByDate = [];
  bool isLive = false;
  int? selectedTab = 3;
  late DateTime selectedDate;
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();

  // final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();
  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    // Two days ahead of today
    selectedDate = today;
    dateList = [
      today.subtract(Duration(days: 2)),
      today.subtract(Duration(days: 1)),
      today,
      today.add(Duration(days: 1)),
      today.add(Duration(days: 2)),
    ];

    var currentSeason =
        widget.league.seasons!.firstWhereOrNull((e) => e.current!);
    _footballMatchBloc.add(GetFixturesByLeagueRequest(
        leagueId: widget.league.league.id.toString(),
        season: (currentSeason != null
                ? currentSeason.year
                : widget.league.seasons!.last.year)
            .toString()));
    // _tabController = new TabController(
    //   vsync: this,
    //   // length: availableBets.contains(widget.league.league.id) ? 3 : 2,
    //   length: _tabList.length,
    // );
    // tabList.addAll(tabBarWidget(leagueList, _tabController));
  }

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _footballMatchBloc,
        ),
        // BlocProvider(
        //   create: (context) => SubjectBloc(),
        // ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<FootballMatchBloc, FootballMatchState>(
            listener: (context, state) {
              if (state is FootballMatchesLoaded) {
                
                setState(() {
                  var groups = groupBy(
                      state.footballMatches,
                      (FootballMatch obj) =>
                          DateFormat("yyyy-MM-dd").parse(obj.fixture.date));

                  matchesByDate = groups.entries
                      .map((entry) => MatchByDate(
                          date: entry.key, // date
                          matches: entry.value.toList()
                            ..sort((a, b) => DateTime.parse(a.fixture.date)
                                .compareTo(DateTime.parse(b.fixture
                                    .date))) // sorted list of Class2 objects
                          ))
                      .toList();
                  var todayMatch = matchesByDate.firstWhereOrNull((element) =>
                      DateFormat("yyyy-MM-dd").format(element.date) ==
                      DateFormat("yyyy-MM-dd").format(DateTime.now()));
                  footballMatches =
                      todayMatch != null ? todayMatch.matches : null;
                  //  footballMatches.firstWhereOrNull((m) =>  DateTime.parse(m.fixture.date).difference(DateTime.now()).isNegative);
                });
              }

              // if (state is BetUpdated) {
              //   Navigator.of(context).pop();

              //   if (updatedBet.length > .0) {
              //     totalValue = updatedBet
              //         .map((e) {
              //           bool homeWin = (e.home.winner! && (!e.away.winner!));
              //           bool awayWin = (e.away.winner! && (!e.home.winner!));
              //           bool draw = e.home.winner! == e.away.winner!;
              //           bool predict = false;
              //           if (e.predict == "Home" && homeWin) {
              //             predict = true;
              //           }
              //           if (e.predict == "Away" && awayWin) {
              //             predict = true;
              //           }

              //           if (e.predict == "Draw" && draw) {
              //             predict = true;
              //           }
              //           if (predict) {
              //             return e.value * 2;
              //           } else {
              //             return 0;
              //           }
              //         })
              //         .toList()
              //         .sum;

              //     updatedBet.forEach((element) {
              //       showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return PredictResult(
              //             bet: element,
              //           );
              //         },
              //       );
              //     });

              //     if (totalValue > 0) {
              //       _footballMatchBloc.add(BetWonUpdateRequest(
              //           id: Constant.auth!.id.toString(),
              //           value: totalValue,
              //           data: updatedBet.map((e) => e.id.toString()).toList()));
              //     }
              //   } else {
              //     Navigator.of(context).pop();
              //   }
              // }

              // if (state is BetLogGet) {
              //   setState(() {
              //     print(state.bet);
              //     print('is bet log ??');
              //     Constant.betList = state.bet;
              //     // showDialog(
              //     //   context: context,
              //     //   barrierDismissible: false,
              //     //   builder: (BuildContext context) {
              //     //     return LoadingBet();
              //     //   },
              //     // );

              //     if (Constant.betList[0].length > 0) {
              //       List<FootballMatch> containBet = footballMatches
              //           .where((e) =>
              //               Constant.betList[0].firstWhereOrNull(
              //                   (element) => element.id == e.fixture.id) !=
              //               null)
              //           .toList();
              //       if (containBet.length > 0) {
              //         containBet.forEach((e) {
              //           Bet? bet = Constant.betList[0].firstWhereOrNull((v) {
              //             if (v.id == e.fixture.id) {
              //               print('which id lai ???????');
              //               print(e.fixture.id);
              //               return true;
              //             } else {
              //               return false;
              //             }
              //           });
              //           String status = e.fixture.status.short!;
              //           if (bet != null &&
              //               (status == 'FT' ||
              //                   status == 'AET' ||
              //                   status == 'PEN')) {
              //             Constant.betList[0].remove(bet);

              //             Constant.betList[1].add(Bet.update(
              //                 bet, e.home.winner!, e.away.winner!, status));

              //             if (Constant.betList[1].length > 200) {
              //               int half_length = Constant.betList[1].length ~/ 2;
              //               Constant.betList[1].removeRange(0, half_length);
              //             }
              //             updatedBet.add(Bet.update(
              //                 bet, e.home.winner!, e.away.winner!, status));
              //             // return true;

              //           }
              //         });

              //         _footballMatchBloc.add(UpdateFinishedBetRequest(
              //             id: Constant.auth!.id.toString(),
              //             bet: Constant.betList[0],
              //             betLog: Constant.betList[1]));

              //         // list.forEach((element) {
              //         //   Bet bet = Constant.betList[1].firstWhereOrNull((v) => element.fixture.id == v.id);

              //         // })
              //       } else {
              //         Navigator.of(context).pop();
              //         // showDialog(
              //         //   context: context,
              //         //   builder: (BuildContext context) {
              //         //     return TestingDialog();
              //         //   },
              //         // );
              //       }
              //     } else {
              //       Navigator.of(context).pop();
              //     }
              //   });
              // }

              // if (state is BetWonUpdated) {
              //   _customerBloc
              //       .add(GetCustomerDetailsRequest(id: Constant.auth!.id));
              //   AdvanceSnackBar(
              //           mode: Mode.ADVANCE,
              //           message: "Bet Won Total Coin: " + totalValue.toString(),
              //           bgColor: Colors.green)
              //       .show(context);
              // }
            },
          ),
          // BlocListener<SubjectBloc, SubjectState>(
          //   listener: (context, state) {
          //     // TODO: implement listener
          //   },
          // ),
        ],
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   color: Constant.color2,
                //   height: 40,
                //   child: TabBar(
                //       key: _tabKey,
                //       controller: _tabController,
                //       // indicator: UnderlineTabIndicator(
                //       //   borderSide: BorderSide(width: 3, color: Colors.white),
                //       // ),
                //       tabs: _tabList

                //       // [
                //       //   // Tab(
                //       //   //     icon: Text('Match',
                //       //   //         style: TextStyle(color: Colors.black))),
                //       //   // if (widget.league.league.id == 39)
                //       //   //   Showcase(
                //       //   //     key: Constant.matchIncomingKey,
                //       //   //     description: "Click here to proceed",
                //       //   //     onTargetClick: () {
                //       //   //       setState(() {
                //       //   //         _tabController.index = 1;
                //       //   //       });
                //       //   //     },
                //       //   //     onToolTipClick: () {
                //       //   //       setState(() {
                //       //   //         _tabController.index = 1;
                //       //   //       });
                //       //   //     },
                //       //   //     disposeOnTap: true,
                //       //   //     // overlayPadding: EdgeInsets.symmetric(horizontal: 30),
                //       //   //     child: Tab(
                //       //   //         icon: Text('Incoming',
                //       //   //             style: TextStyle(color: Colors.black))),
                //       //   //   ),
                //       //   // if (widget.league.league.id != 39)
                //       //   //   Tab(
                //       //   //       icon: Text('Incoming',
                //       //   //           style: TextStyle(color: Colors.black))),
                //       //   // if (widget.league.league.id == 39)
                //       //   //   Showcase(
                //       //   //     key: Constant.matchBetKey,

                //       //   //     description:
                //       //   //         "Users can see list of the matches that has been bet, and the result of bet",
                //       //   //     // overlayPadding: EdgeInsets.symmetric(horizontal: 30),
                //       //   //     child: Tab(
                //       //   //         icon: Text('Bet Log',
                //       //   //             style: TextStyle(color: Colors.black))),
                //       //   //   ),
                //       //   // if (widget.league.league.id != 39 &&
                //       //   //     availableBets.contains(widget.league.league.id))
                //       //   //   Tab(
                //       //   //       icon: Text('Bet Log',
                //       //   //           style: TextStyle(color: Colors.black))),
                //       // ]

                //       ),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 0.5))),
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedTab != 0) {
                              selectedTab = 0;
                              database = FirebaseDatabase.instance.ref('62');
                              isLive = true;
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: selectedTab == 0
                                    ? Constant.color2
                                    : Colors.white,
                                // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Live",
                                style: TextStyle(
                                    color: Constant.backgroundColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )),
                      Expanded(
                        flex: 5,
                        child: selectedTab != -1
                            ? Row(
                                children: dateList
                                    .asMap()
                                    .entries
                                    .map(
                                      (e) => Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (database != null && isLive) {
                                                database!.onValue.drain();
                                                database = null;
                                                isLive = false;
                                              }
                                              selectedTab = (e.key + 1);

                                              var selectedDate = matchesByDate
                                                  .firstWhereOrNull(
                                                (element) =>
                                                    DateFormat('dd MMM')
                                                        .format(element.date) ==
                                                    DateFormat('dd MMM')
                                                        .format(e.value),
                                              );

                                              footballMatches =
                                                  selectedDate != null
                                                      ? selectedDate.matches
                                                      : null;
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  e.key == 2
                                                      ? "Today"
                                                      : DateFormat('E')
                                                          .format(e.value),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: selectedTab ==
                                                              (e.key + 1)
                                                          ? Constant.color2
                                                          : Colors.white)),
                                              AutoSizeText(
                                                DateFormat('dd MMM')
                                                    .format(e.value),
                                                softWrap: true,
                                                wrapWords: false,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: selectedTab ==
                                                            (e.key + 1)
                                                        ? Constant.color2
                                                        : Colors.white),
                                                minFontSize: 3,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList())
                            : Row(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedDate = selectedDate
                                            .subtract(Duration(days: 1));
                                        var picker = (dateList.indexWhere(
                                            (element) =>
                                                DateFormat("yyyy-MM-dd")
                                                    .format(element) ==
                                                DateFormat("yyyy-MM-dd")
                                                    .format(selectedDate)));

                                        selectedTab =
                                            picker != -1 ? picker + 1 : -1;
                                        var selectedDateMatch =
                                            matchesByDate.firstWhereOrNull(
                                          (element) =>
                                              DateFormat('dd MMM')
                                                  .format(element.date) ==
                                              DateFormat('dd MMM')
                                                  .format(selectedDate),
                                        );
                                        footballMatches =
                                            selectedDateMatch != null
                                                ? selectedDateMatch.matches
                                                : null;
                                      });
                                    },
                                    child: Icon(FontAwesomeIcons.caretLeft,
                                        size: 20, color: Colors.white),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            DateFormat('EEEE')
                                                .format(selectedDate),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Constant.color2)),
                                        AutoSizeText(
                                          DateFormat('dd MMM yyyy')
                                              .format(selectedDate),
                                          softWrap: true,
                                          wrapWords: false,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Constant.color2),
                                          minFontSize: 3,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedDate =
                                            selectedDate.add(Duration(days: 1));
                                        var picker = (dateList.indexWhere(
                                            (element) =>
                                                DateFormat("yyyy-MM-dd")
                                                    .format(element) ==
                                                DateFormat("yyyy-MM-dd")
                                                    .format(selectedDate)));

                                        selectedTab =
                                            picker != -1 ? picker + 1 : -1;
                                        var selectedDateMatch =
                                            matchesByDate.firstWhereOrNull(
                                          (element) =>
                                              DateFormat('dd MMM')
                                                  .format(element.date) ==
                                              DateFormat('dd MMM')
                                                  .format(selectedDate),
                                        );
                                        footballMatches =
                                            selectedDateMatch != null
                                                ? selectedDateMatch.matches
                                                : null;
                                      });
                                    },
                                    child: Icon(FontAwesomeIcons.caretRight,
                                        size: 20, color: Colors.white),
                                  ),
                                )
                              ]),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(DateTime.now().year + 1),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      dialogBackgroundColor:
                                          Constant.backgroundColor,
                                      colorScheme: ColorScheme.light(
                                        primary: Constant
                                            .color1, // header background color
                                        onPrimary:
                                            Colors.white, // header text color
                                        onSurface:
                                            Colors.white, // body text color
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Constant
                                              .color2, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                });

                            setState(() {
                              if (date != null) {
                                if (database != null && isLive) {
                                  database!.onValue.drain();
                                  database = null;
                                  database = null;
                                  isLive = false;
                                }

                                selectedDate = date;
                                var picker = (dateList.indexWhere((element) =>
                                    DateFormat("yyyy-MM-dd").format(element) ==
                                    DateFormat("yyyy-MM-dd")
                                        .format(selectedDate)));

                                selectedTab = picker != -1 ? picker + 1 : -1;
                                var selectedDateMatch =
                                    matchesByDate.firstWhereOrNull(
                                  (element) =>
                                      DateFormat('dd MMM')
                                          .format(element.date) ==
                                      DateFormat('dd MMM').format(selectedDate),
                                );
                                footballMatches = selectedDateMatch != null
                                    ? selectedDateMatch.matches
                                    : null;
                              }
                            });
                          },
                          child: Row(children: [
                            // Icon(FontAwesomeIcons.stream, size: 10),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Icon(
                                      FontAwesomeIcons.calendarAlt,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(FontAwesomeIcons.caretDown,
                                  size: 12, color: Colors.white),
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: BlocBuilder<FootballMatchBloc, FootballMatchState>(
                    builder: (context, state) {
                      if (state is FootballMatchesError) {
                        return ErrorWidget(state.message);
                      } else if (state is LoadAllFootballMatch) {
                        return LoadingWidget();
                      } else {
                        if (isLive) {
                          return StreamBuilder(
                              stream:
                                  database != null ? database!.onValue : null,
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
                                      List<FootballMatch> list = jsonvalue
                                          .entries
                                          .map((entry) =>
                                              FootballMatchModel.fromJson(
                                                  jsonDecode(
                                                      jsonEncode(entry.value))))
                                          .toList();
                                      if (list.length > 0) {
                                        liveMatches = list
                                            .where((e) =>
                                                e.league!.name == widget.league)
                                            .toList();
                                      }
                                      Constant.liveData.add(list);
                                    }
                                  }

                                  return

                                      // Showcase(
                                      //   key: _key1,
                                      //   description:
                                      //       "In live section, can see any league that currently on live.",
                                      //   child:

                                      liveMatches != null &&
                                              liveMatches!.length > 0
                                          ? Container(
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
                                                      child: ListView.builder(
                                                          addAutomaticKeepAlives:
                                                              false,
                                                          shrinkWrap: true,
                                                          // order: GroupedListOrder.DESC,
                                                          // sort: true,
                                                          itemCount:
                                                              liveMatches!
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            int extraTime = 0;

                                                            List<Event>?
                                                                awayEvent;
                                                            List<Event>?
                                                                homeEvent;
                                                            bool matchOngoing =
                                                                false;
                                                            bool isFavorite =
                                                                false;
                                                            FootballMatch
                                                                match =
                                                                liveMatches![
                                                                    index];
                                                            if (match.events !=
                                                                    null &&
                                                                match.events!
                                                                        .length >
                                                                    0 &&
                                                                (match.fixture.status.short ==
                                                                            '1H' &&
                                                                        match.fixture.status.elapsedTime ==
                                                                            45 ||
                                                                    match.fixture.status.short ==
                                                                            '2H' &&
                                                                        match.fixture.status.elapsedTime ==
                                                                            90) &&
                                                                match
                                                                        .events!
                                                                        .last
                                                                        .time
                                                                        .extra !=
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
                                                                          match
                                                                              .away
                                                                              .id)
                                                                  .toList();
                                                              homeEvent = match
                                                                  .events!
                                                                  .where((element) =>
                                                                      element.team !=
                                                                          null &&
                                                                      element.team!
                                                                              .id ==
                                                                          match
                                                                              .home
                                                                              .id)
                                                                  .toList();
                                                            }

                                                            matchOngoing = (match
                                                                        .fixture
                                                                        .status
                                                                        .short !=
                                                                    'FT' &&
                                                                match
                                                                        .fixture
                                                                        .status
                                                                        .short !=
                                                                    'AET' &&
                                                                match
                                                                        .fixture
                                                                        .status
                                                                        .short !=
                                                                    'PEN');
                                                            isFavorite = Constant
                                                                    .favoriteList
                                                                    .firstWhereOrNull((element) =>
                                                                        element
                                                                            .fixture
                                                                            .id ==
                                                                        match
                                                                            .fixture
                                                                            .id) !=
                                                                null;

                                                            return GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                        MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      FootballMatchInfoPage(
                                                                          match:
                                                                              match),
                                                                ));
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        5.0),
                                                                child: Column(
                                                                    children: [
                                                                      Container(
                                                                        height: match.events != null
                                                                            ? MediaQuery.of(context).size.height *
                                                                                0.12
                                                                            : MediaQuery.of(context).size.height *
                                                                                0.1,
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.white,
                                                                            borderRadius: new BorderRadius.all(
                                                                              const Radius.circular(20.0),
                                                                            )),
                                                                        child: Column(
                                                                            children: [
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
                                                                                          height: MediaQuery.of(context).size.height * 0.01,
                                                                                        ),
                                                                                        (match.fixture.status.short == '1H' || match.fixture.status.short == '2H' || match.fixture.status.short == 'P' || match.fixture.status.short == 'ET' || match.fixture.status.short == 'BT' || match.fixture.status.short == 'HT')
                                                                                            ? AutoSizeText(
                                                                                                (match.fixture.status.elapsedTime != null ? match.fixture.status.elapsedTime.toString() : '') + (match.events != null && ((match.fixture.status.short == '1H' && match.fixture.status.elapsedTime == 45) || (match.fixture.status.short == '2H' && match.fixture.status.elapsedTime == 90)) ? '+' : '') + (extraTime != 0 ? extraTime.toString() : '') + (match.fixture.status.elapsedTime != null ? ' : ' : '') + (extraTime != 0 ? match.fixture.status.short! : match.fixture.status.long!),
                                                                                                style: TextStyle(
                                                                                                  color: Colors.green,
                                                                                                ),
                                                                                                softWrap: false,
                                                                                                maxFontSize: 12,
                                                                                                minFontSize: 6,
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
                                                                                                    //                 "////${match.goal != null && match.goal!.home != null ? (homeEvent != null && match.goal!.home! > homeEvent!.map((e) => e.type.toLowerCase() == 'goal').length ? match.goal!.home! : homeEvent!.map((e) => e.type.toLowerCase() == 'goal').length) : '0'} - ${match.goal != null && match.goal!.away != null ? match.goal!.away : '0'}",

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
                                                                                                  )
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
                                                                    ]),
                                                              ),
                                                            );
                                                          }),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                  FootballMatchNoLiveData(),
                                                  // SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  // StatisticsButton(),
                                                ]);
                                  // );
                                } else {
                                  return NoDataWidget();
                                }
                              });
                        } else {
                          if (footballMatches != null &&
                              footballMatches!.length > 0) {
                            return const SizedBox();
                            // return FootballMatchListTest(
                            //   league: widget.league,
                            //   footballMatches: footballMatches!,
                            // );
                          } else {
                            return Container(
                                child: Center(
                                    child: Text(
                                        'There is no match for this date.')));
                          }
                        }

                        // return FootballMatchListTest(
                        //   league: widget.league,
                        //   footballMatches: matchesByDate[0].matches,
                        // );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
