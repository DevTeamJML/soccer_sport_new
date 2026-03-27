import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:advance_notification/advance_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/authentication/presentation/widget/login_loading_dialog.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/error_widget.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/dialog/loading_bet.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/dialog/predict_result.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/dialog/testing_dialog.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_date_seperator.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_list_tile.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/statistics_button.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import '../../../core/constant/analytics_service.dart';
import '../../../injection_container.dart';

class FootballMatchList extends StatefulWidget {
  final LeagueDetails league;
  FootballMatchList({required this.league});

  @override
  _FootballMatchListState createState() => _FootballMatchListState();
}

class _FootballMatchListState extends State<FootballMatchList>
    with WidgetsBindingObserver {
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();
  final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();

  List<FootballMatch> footballMatches = [];
  List<FootballMatch> cloneList = [];
  List<FootballMatch> searchedMatches = [];
  List<FootballMatch> liveMatches = [];
  List<Bet> updatedBet = [];
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();

  List<String> dateList = ['All'];
  String selectedDate = 'All';

  DatabaseReference? testing;
  final TextEditingController _controller = TextEditingController();
  String searchValue = '';
  int totalValue = 0;
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    // FirebaseDatabase.instance.ref('62').get().then((value) {
    //   FootballMatchModel test = FootballMatchModel.fromJson(
    //       jsonDecode(jsonEncode(value.children.first.value)));
    //   print(test.fixture.id);
    // });

    // Query query = FirebaseDatabase.instance
    //     .ref('62')
    //     .orderByChild('fixture/id')
    //     .equalTo('720006');
    // print(query.get());
    _footballMatchBloc.add(GetFixturesByLeagueRequest(
        leagueId: widget.league.league.id.toString(),
        season: widget.league.seasons!.last.year.toString()));

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (Constant.auth != null && Constant.showcaseBool == false)
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return LoginLoadingDialog();
          },
        );

      // if (Constant.showcaseBool && widget.league.league.id == 39)
      //   setState(() {
      //     ShowCaseWidget.of(context).startShowCase([
      //       Constant.matchIncomingKey,
      //     ]);
      //   });
    });

    serviceLocator<AnalyticsService>().logScreens(
        name: '/footballMatchPage/' + widget.league.league.name + '/match');
    super.initState();
  }

  Future<void> _onRefresh() async {
    // monitor network fetch
    _footballMatchBloc.add(GetFixturesByLeagueRequest(
        leagueId: widget.league.league.id.toString(),
        season: widget.league.seasons!.last.year.toString()));
    return Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    // _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _footballMatchBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _footballMatchBloc.add(GetFixturesByLeagueRequest(
            leagueId: widget.league.league.id.toString(),
            season: widget.league.seasons!.last.year.toString()));
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return LoginLoadingDialog();
          },
        );
        Timer(
          const Duration(seconds: 1),
          () {
            Navigator.of(context).pop();
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FootballMatchBloc>(
          create: (_) => _footballMatchBloc,
        ),
        BlocProvider(
          create: (context) => _customerBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<FootballMatchBloc, FootballMatchState>(
            listener: (context, state) {
              if (state is FootballMatchesLoaded) {
                setState(() {
                  footballMatches = state.footballMatches;
                  //  footballMatches.firstWhereOrNull((m) =>  DateTime.parse(m.fixture.date).difference(DateTime.now()).isNegative);

                  cloneList = List.from(footballMatches);
                  dateList.addAll(Set.from(
                    footballMatches.map(
                      (e) => Constant.formattedDate(
                        (DateTime.parse(e.fixture.date).toLocal()),
                      ),
                    ),
                  ));
                  if (Constant.auth != null && Constant.showcaseBool == false) {
                    _footballMatchBloc.add(
                        GetBetLogRequest(id: Constant.auth!.id.toString()));
                  }
                });
              }

              if (state is BetUpdated) {
                Navigator.of(context).pop();

                if (updatedBet.length > .0) {
                  totalValue = updatedBet
                      .map((e) {
                        bool homeWin = (e.home.winner! && (!e.away.winner!));
                        bool awayWin = (e.away.winner! && (!e.home.winner!));
                        bool draw = e.home.winner! == e.away.winner!;
                        bool predict = false;
                        if (e.predict == "Home" && homeWin) {
                          predict = true;
                        }
                        if (e.predict == "Away" && awayWin) {
                          predict = true;
                        }

                        if (e.predict == "Draw" && draw) {
                          predict = true;
                        }
                        if (predict) {
                          return e.value * 2;
                        } else {
                          return 0;
                        }
                      })
                      .toList()
                      .sum;

                  updatedBet.forEach((element) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PredictResult(
                          bet: element,
                        );
                      },
                    );
                  });

                  if (totalValue > 0) {
                    _footballMatchBloc.add(BetWonUpdateRequest(
                        id: Constant.auth!.id.toString(),
                        value: totalValue,
                        data: updatedBet.map((e) => e.id.toString()).toList()));
                  }
                } else {
                  Navigator.of(context).pop();
                }
              }

              if (state is BetLogGet) {
                setState(() {
                  Constant.betList = state.bet;
                  // showDialog(
                  //   context: context,
                  //   barrierDismissible: false,
                  //   builder: (BuildContext context) {
                  //     return LoadingBet();
                  //   },
                  // );

                  if (Constant.betList[0].length > 0) {
                    List<FootballMatch> containBet = footballMatches
                        .where((e) =>
                            Constant.betList[0].firstWhereOrNull(
                                (element) => element.id == e.fixture.id) !=
                            null)
                        .toList();
                    if (containBet.length > 0) {
                      containBet.forEach((e) {
                        Bet? bet = Constant.betList[0].firstWhereOrNull((v) {
                          if (v.id == e.fixture.id) {
                            return true;
                          } else {
                            return false;
                          }
                        });
                        String status = e.fixture.status.short!;
                        if (bet != null &&
                            (status == 'FT' ||
                                status == 'AET' ||
                                status == 'PEN')) {
                          Constant.betList[0].remove(bet);

                          Constant.betList[1].add(Bet.update(
                              bet, e.home.winner!, e.away.winner!, status));

                          if (Constant.betList[1].length > 200) {
                            int half_length = Constant.betList[1].length ~/ 2;
                            Constant.betList[1].removeRange(0, half_length);
                          }
                          updatedBet.add(Bet.update(
                              bet, e.home.winner!, e.away.winner!, status));
                          // return true;
                        }
                      });

                      _footballMatchBloc.add(UpdateFinishedBetRequest(
                          id: Constant.auth!.id.toString(),
                          bet: Constant.betList[0],
                          betLog: Constant.betList[1]));

                      // list.forEach((element) {
                      //   Bet bet = Constant.betList[1].firstWhereOrNull((v) => element.fixture.id == v.id);

                      // })
                    } else {
                      Navigator.of(context).pop();
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return TestingDialog();
                      //   },
                      // );
                    }
                  } else {
                    Navigator.of(context).pop();
                  }
                });
              }

              if (state is BetWonUpdated) {
                _customerBloc
                    .add(GetCustomerDetailsRequest(id: Constant.auth!.id));
                AdvanceSnackBar(
                        mode: Mode.ADVANCE,
                        message: "Bet Won Total Coin: " + totalValue.toString(),
                        bgColor: Colors.green)
                    .show(context);
              }
            },
          ),
          BlocListener<CustomerBloc, CustomerState>(
            listener: (context, state) {
              if (state is CustomerDetailsLoaded) {
                setState(() {
                  Constant.customer = state.customer;
                });
              }
            },
          ),
        ],
        child: Column(
          children: [
            // Showcase(
            //   key: _key1,
            //   description: "Users can filter the matches by selecting the date",
            //   child:

            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(color: Colors.white)),
                  child: GestureDetector(
                      onTap: () {
                        showPicker(context);
                      },
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.calendarAlt,
                              size: 22,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              selectedDate,
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              FontAwesomeIcons.chevronDown,
                              size: 10,
                            ),
                          ])),
                ),
              ),
              // ),
            ),
            // Showcase(
            //   key: _key2,
            //   description:
            //       "Users can search league's team with the search bar to filter the searched team's match",
            //   child:

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlineSearchBar(
                textEditingController: _controller,
                onClearButtonPressed: (v) {
                  setState(() {
                    searchedMatches.clear();
                    cloneList = List.from(footballMatches);
                    searchValue = '';
                  });
                },
                onSearchButtonPressed: (value) {
                  setState(() {
                    // cloneList.map((e) {
                    //   if (e.league!.name
                    //       .replaceAll(' ', '')
                    //       .toLowerCase()
                    //       .contains(value.replaceAll(' ', '').toLowerCase())) {
                    //     return e;
                    //   }
                    // }).toList();
                    searchedMatches = cloneList
                        .where((e) =>
                            e.away.name
                                .replaceAll(' ', '')
                                .toLowerCase()
                                .contains(
                                    value.replaceAll(' ', '').toLowerCase()) ||
                            e.home.name
                                .replaceAll(' ', '')
                                .toLowerCase()
                                .contains(
                                    value.replaceAll(' ', '').toLowerCase()))
                        .toList();
                    // searchedMatches = cloneList;
                    searchValue = value;
                  });
                },
              ),
              // ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BlocBuilder(
                          bloc: _footballMatchBloc,
                          builder: (context, state) {
                            if (state is LoadAllFootballMatch) {
                              return LoadingWidget();
                            } else if (state is FootballMatchesError) {
                              return ErrorsWidget();
                            } else {
                              if (footballMatches.length > 0) {
                                // return Expanded(
                                //   child: RefreshIndicator(
                                //     onRefresh: _onRefresh,
                                //     child:
                                //   ),
                                // );
                                if (searchValue != '') {
                                  if (searchedMatches.length > 0) {
                                    return Expanded(
                                      child: GroupedListView<FootballMatch,
                                              String>(
                                          addAutomaticKeepAlives: false,
                                          shrinkWrap: true,
                                          order: GroupedListOrder.DESC,
                                          itemComparator: (item1, item2) =>
                                              DateTime.parse(item1.fixture.date)
                                                  .compareTo(DateTime.parse(
                                                      item2.fixture.date)),
                                          elements: selectedDate == 'All'
                                              ? searchedMatches
                                              : searchedMatches.where((e) {
                                                  return Constant.formattedDate(
                                                          (DateTime.parse(e
                                                                  .fixture.date)
                                                              .toLocal())) ==
                                                      selectedDate;
                                                }).toList(),
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
                                              FootballMatch match, int index) {
                                            FootballMatch? liveMatch =
                                                liveMatches.firstWhereOrNull(
                                                    (v) =>
                                                        v.fixture.id ==
                                                        match.fixture.id);
                                            if (liveMatch != null) {
                                              return FootballMatchListTile(
                                                key: ValueKey(
                                                    liveMatch.fixture.id),
                                                footballMatch: liveMatch,
                                                isIncoming: false,
                                                live: true,
                                                showcasebool: true,
                                              );
                                            } else {
                                              if (match.fixture.status.short ==
                                                      '2H' &&
                                                  match.fixture.status
                                                          .elapsedTime ==
                                                      90) {
                                                match.fixture.status.short =
                                                    'FT';
                                              }
                                              return FootballMatchListTile(
                                                key: ValueKey(match.fixture.id),
                                                footballMatch: match,
                                                isIncoming: false,
                                                live: false,
                                                showcasebool: true,
                                              );
                                            }
                                          }),
                                    );
                                  } else {
                                    return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text('No search result'),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          StatisticsButton(),
                                        ]);
                                  }
                                } else {
                                  return Expanded(
                                    child: GroupedListView<FootballMatch,
                                            String>(
                                        addAutomaticKeepAlives: false,
                                        shrinkWrap: true,
                                        order: GroupedListOrder.DESC,
                                        itemComparator: (item1, item2) =>
                                            DateTime.parse(item1.fixture.date)
                                                .compareTo(DateTime.parse(
                                                    item2.fixture.date)),
                                        elements: selectedDate == 'All'
                                            ? footballMatches
                                            : footballMatches.where((e) {
                                                return Constant.formattedDate(
                                                        (DateTime.parse(
                                                                e.fixture.date)
                                                            .toLocal())) ==
                                                    selectedDate;
                                              }).toList(),
                                        groupBy: (match) => Constant.formattedDate(
                                            (DateTime.parse(match.fixture.date)
                                                .toLocal())),
                                        groupSeparatorBuilder: (String date) =>
                                            FootballMatchDateSeperator(
                                              date: date,
                                            ),
                                        indexedItemBuilder: (context,
                                            FootballMatch match, int index) {
                                          FootballMatch? liveMatch = liveMatches
                                              .firstWhereOrNull((v) =>
                                                  v.fixture.id ==
                                                  match.fixture.id);
                                          if (liveMatch != null) {
                                            return FootballMatchListTile(
                                              key: ValueKey(
                                                  liveMatch.fixture.id),
                                              footballMatch: liveMatch,
                                              isIncoming: false,
                                              live: true,
                                              showcasebool: true,
                                            );
                                          } else {
                                            if (match.fixture.status.short ==
                                                    '2H' &&
                                                match.fixture.status
                                                        .elapsedTime ==
                                                    90) {
                                              match.fixture.status.short = 'FT';
                                            }
                                            return FootballMatchListTile(
                                              key: ValueKey(match.fixture.id),
                                              footballMatch: match,
                                              isIncoming: false,
                                              live: false,
                                              showcasebool: true,
                                            );
                                          }
                                        }),
                                  );
                                }
                              } else {
                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      NoDataWidget(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      StatisticsButton(),
                                    ]);
                              }
                            }
                          }),
                    ],
                  ),
                ),
              ),
            )
            // Expanded(
            //   child:
            // StreamBuilder(
            //       stream: testing != null ? testing!.onValue : null,
            //       builder: (context, snapshot) {
            //         liveMatches = [];
            //         if (snapshot.connectionState == ConnectionState.waiting) {
            //           return LoadingWidget();
            //         } else if (snapshot.hasData) {
            //           print('has firebase data2');

            //           DatabaseEvent data = snapshot.data as DatabaseEvent;
            //           print(data.snapshot.value);
            //           if (data.snapshot.value != null) {
            //             var jsonvalue = Map<String, dynamic>.from(
            //                 data.snapshot.value as LinkedHashMap);
            //             // print(jsonvalue);
            //             if (jsonvalue.isNotEmpty &&
            //                 footballMatches.length > 0) {
            //               jsonvalue.forEach((key, value) {
            //                 FootballMatch match = FootballMatchModel.fromJson(
            //                     jsonDecode(jsonEncode(value)));
            //                 if (footballMatches.indexWhere((element) =>
            //                         element.fixture.id == match.fixture.id) !=
            //                     -1) {
            //                   footballMatches[footballMatches.indexWhere(
            //                       (element) =>
            //                           element.fixture.id ==
            //                           match.fixture.id)] = match;
            //                 }

            //                 liveMatches.add(match);
            //               });
            //             }
            //           }
            //           return Container(
            //             width: double.infinity,
            //             height: double.infinity,
            //             child: Padding(
            //               padding: EdgeInsets.zero,
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 children: [
            //                   BlocBuilder(
            //                       bloc: _footballMatchBloc,
            //                       builder: (context, state) {
            //                         if (state is LoadAllFootballMatch) {
            //                           return LoadingWidget();
            //                         } else if (state is FootballMatchesError) {
            //                           return ErrorsWidget();
            //                         } else {
            //                           if (footballMatches.length > 0) {
            //                             // return Expanded(
            //                             //   child: RefreshIndicator(
            //                             //     onRefresh: _onRefresh,
            //                             //     child:
            //                             //   ),
            //                             // );
            //                             if (searchValue != '') {
            //                               if (searchedMatches.length > 0) {
            //                                 return Expanded(
            //                                   child: GroupedListView<
            //                                           FootballMatch, String>(
            //                                       addAutomaticKeepAlives: false,
            //                                       shrinkWrap: true,
            //                                       order: GroupedListOrder.DESC,
            //                                       itemComparator: (item1, item2) =>
            //                                           DateTime.parse(item1.fixture.date).compareTo(DateTime.parse(
            //                                               item2.fixture.date)),
            //                                       elements:
            //                                           selectedDate == 'All'
            //                                               ? searchedMatches
            //                                               : searchedMatches
            //                                                   .where((e) {
            //                                                   return Constant.formattedDate((DateTime.parse(e
            //                                                               .fixture
            //                                                               .date)
            //                                                           .toLocal())) ==
            //                                                       selectedDate;
            //                                                 }).toList(),
            //                                       groupBy: (match) =>
            //                                           Constant.formattedDate(
            //                                               (DateTime.parse(match.fixture.date)
            //                                                   .toLocal())),
            //                                       groupSeparatorBuilder: (String date) =>
            //                                           FootballMatchDateSeperator(
            //                                             date: date,
            //                                           ),
            //                                       indexedItemBuilder: (context, FootballMatch match, int index) {
            //                                         FootballMatch? liveMatch =
            //                                             liveMatches
            //                                                 .firstWhereOrNull(
            //                                                     (v) =>
            //                                                         v.fixture
            //                                                             .id ==
            //                                                         match
            //                                                             .fixture
            //                                                             .id);
            //                                         if (liveMatch != null) {
            //                                           return FootballMatchListTile(
            //                                             footballMatch:
            //                                                 liveMatch,
            //                                             isIncoming: false,
            //                                             live: true,
            //                                           );
            //                                         } else {
            //                                           if (match.fixture.status
            //                                                       .short ==
            //                                                   '2H' &&
            //                                               match.fixture.status
            //                                                       .elapsedTime ==
            //                                                   90) {
            //                                             match.fixture.status
            //                                                 .short = 'FT';
            //                                           }
            //                                           return FootballMatchListTile(
            //                                             footballMatch: match,
            //                                             isIncoming: false,
            //                                             live: false,
            //                                           );
            //                                         }
            //                                       }),
            //                                 );
            //                               } else {
            //                                 return Column(
            //                                     mainAxisAlignment:
            //                                         MainAxisAlignment.center,
            //                                     children: [
            //                                       Center(
            //                                         child: Text(
            //                                             'No search result'),
            //                                       ),
            //                                       SizedBox(
            //                                         height: 10,
            //                                       ),
            //                                       StatisticsButton(),
            //                                     ]);
            //                               }
            //                             } else {
            //                               return Expanded(
            //                                 child: GroupedListView<
            //                                         FootballMatch, String>(
            //                                     addAutomaticKeepAlives: false,
            //                                     shrinkWrap: true,
            //                                     order: GroupedListOrder.DESC,
            //                                     itemComparator: (item1, item2) =>
            //                                         DateTime.parse(item1.fixture.date).compareTo(DateTime.parse(
            //                                             item2.fixture.date)),
            //                                     elements: selectedDate == 'All'
            //                                         ? footballMatches
            //                                         : footballMatches
            //                                             .where((e) {
            //                                             return Constant.formattedDate(
            //                                                     (DateTime.parse(e
            //                                                             .fixture
            //                                                             .date)
            //                                                         .toLocal())) ==
            //                                                 selectedDate;
            //                                           }).toList(),
            //                                     groupBy: (match) => Constant.formattedDate(
            //                                         (DateTime.parse(match.fixture.date)
            //                                             .toLocal())),
            //                                     groupSeparatorBuilder: (String date) =>
            //                                         FootballMatchDateSeperator(
            //                                           date: date,
            //                                         ),
            //                                     indexedItemBuilder:
            //                                         (context, FootballMatch match, int index) {
            //                                       FootballMatch? liveMatch =
            //                                           liveMatches
            //                                               .firstWhereOrNull(
            //                                                   (v) =>
            //                                                       v.fixture
            //                                                           .id ==
            //                                                       match.fixture
            //                                                           .id);
            //                                       if (liveMatch != null) {
            //                                         return FootballMatchListTile(
            //                                           footballMatch: liveMatch,
            //                                           isIncoming: false,
            //                                           live: true,
            //                                         );
            //                                       } else {
            //                                         if (match.fixture.status
            //                                                     .short ==
            //                                                 '2H' &&
            //                                             match.fixture.status
            //                                                     .elapsedTime ==
            //                                                 90) {
            //                                           match.fixture.status
            //                                               .short = 'FT';
            //                                         }
            //                                         return FootballMatchListTile(
            //                                           footballMatch: match,
            //                                           isIncoming: false,
            //                                           live: false,
            //                                         );
            //                                       }
            //                                     }),
            //                               );
            //                             }
            //                           } else {
            //                             return Column(
            //                                 mainAxisAlignment:
            //                                     MainAxisAlignment.center,
            //                                 children: [
            //                                   NoDataWidget(),
            //                                   SizedBox(
            //                                     height: 10,
            //                                   ),
            //                                   StatisticsButton(),
            //                                 ]);
            //                           }
            //                         }
            //                       }),
            //                 ],
            //               ),
            //             ),
            //           );
            //         } else {
            //           return ErrorsWidget();
            //         }
            //       }),
            // ),
          ],
        ),
      ),
    );
  }

  showPicker(
    BuildContext context,
  ) {
    Picker(
        adapter: PickerDataAdapter<String>(
            data: dateList
                .map((e) => PickerItem(text: Text(e), value: e))
                .toList()),
        reversedOrder: false,
        changeToFirst: true,
        selecteds: [0],
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          setState(() {
            selectedDate = picker.getSelectedValues()[0];
          });
        }).showModal(this.context);
  }
}
