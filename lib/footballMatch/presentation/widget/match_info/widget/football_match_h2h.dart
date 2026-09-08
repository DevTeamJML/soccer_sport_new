import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/predict.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_list_tile.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/match_info/widget/football_match_h2h_summary.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/match_info/widget/h2h_list_tile.dart';

class FootballMatchH2H extends StatefulWidget {
  final FootballMatch match;
  final FootballMatchBloc bloc;

  const FootballMatchH2H({required this.match, required this.bloc});

  @override
  State<FootballMatchH2H> createState() => _FootballMatchH2HState();
}

class _FootballMatchH2HState extends State<FootballMatchH2H> {
  late FootballMatchBloc _footballMatchBloc;
  Predict? predict;
  late FootballMatch match;
  List<String> homeLast5Form = [];
  List<String> awayLast5Form = [];
  Map<String, List<FootballMatch>> h2hSummary = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _footballMatchBloc = widget.bloc;
    match = widget.match;
    _footballMatchBloc
        .add(GetMatchPredictRequest(id: widget.match.fixture.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FootballMatchBloc, FootballMatchState>(
      bloc: _footballMatchBloc,
      listener: (context, state) {
        if (state is MatchPredictGet) {
          setState(() {
            predict = state.stats;
            if (predict!.h2h.length > 5) {
              h2hSummary['Overall'] = predict!.h2h;
              h2hSummary['Last 5'] = predict!.h2h.sublist(0, 5);
            }
            if (predict!.home.leagueStat.form != null &&
                predict!.away.leagueStat.form != null) {
              int homeFirstIndex = predict!.home.leagueStat.form!.length >= 5
                  ? predict!.home.leagueStat.form!.length - 5
                  : 0;

              int awayFirstIndex = predict!.away.leagueStat.form!.length >= 5
                  ? predict!.away.leagueStat.form!.length - 5
                  : 0;

              homeLast5Form = predict!.home.leagueStat.form!
                  .substring(homeFirstIndex)
                  .split('');
              awayLast5Form = predict!.away.leagueStat.form!
                  .substring(awayFirstIndex)
                  .split('');
            }
          });
        }
      },
      child: BlocBuilder<FootballMatchBloc, FootballMatchState>(
        bloc: _footballMatchBloc,
        builder: (context, state) {
          if (state is GettingMatchPredict) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: double.maxFinite,
                child: LoadingWidget());
          } else if (state is FootballMatchesError) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: double.maxFinite,
                child: ErrorWidget(state.message));
          } else {
            if (predict != null) {
              var winPredictBar = MediaQuery.of(context).size.width * 0.9;
              var height = MediaQuery.of(context).size.height;

              if (h2hSummary.length > 0 &&
                  homeLast5Form.length > 0 &&
                  awayLast5Form.length > 0) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // if (match.fixture.status.short != "FT" &&
                      //     match.fixture.status.short != "AET" &&
                      //     match.fixture.status.short != "PEN")
                      //   Container(
                      //     margin: EdgeInsets.symmetric(vertical: height * 0.01),
                      //     height: MediaQuery.of(context).size.height * 0.12,
                      //     width: winPredictBar,
                      //     child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Text(
                      //             "Win Probability",
                      //             style: TextStyle(
                      //                 fontWeight: FontWeight.bold, fontSize: 16),
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.symmetric(
                      //                 vertical: height * 0.01),
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Container(
                      //                   width: winPredictBar *
                      //                       (predict!.predictions.home / 100),
                      //                   height: height * 0.02,
                      //                   color: Constant.color2,
                      //                 ),
                      //                 Container(
                      //                   width: winPredictBar *
                      //                       (predict!.predictions.draw / 100),
                      //                   height: height * 0.02,
                      //                   color: Colors.grey,
                      //                 ),
                      //                 Container(
                      //                   width: winPredictBar *
                      //                       (predict!.predictions.away / 100),
                      //                   height: height * 0.02,
                      //                   color: Colors.red[600],
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.symmetric(
                      //                 horizontal:
                      //                     MediaQuery.of(context).size.width *
                      //                         0.05),
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Expanded(
                      //                     flex: 2,
                      //                     child: Column(
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           Row(
                      //                             children: [
                      //                               Text("Home"),
                      //                               SizedBox(
                      //                                 width: 5,
                      //                               ),
                      //                               Container(
                      //                                 color: Constant.color2,
                      //                                 height: 10,
                      //                                 width: 10,
                      //                               )
                      //                             ],
                      //                           ),
                      //                           Text(predict!.predictions.home
                      //                                   .toString() +
                      //                               "%")
                      //                         ])),
                      //                 Expanded(
                      //                   child: Center(
                      //                       child: Column(children: [
                      //                     Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.center,
                      //                       children: [
                      //                         Text("Draw"),
                      //                         SizedBox(
                      //                           width: 5,
                      //                         ),
                      //                         Container(
                      //                           color: Colors.grey,
                      //                           height: 10,
                      //                           width: 10,
                      //                         )
                      //                       ],
                      //                     ),
                      //                     Text(predict!.predictions.draw
                      //                             .toString() +
                      //                         "%")
                      //                   ])),
                      //                 ),
                      //                 Expanded(
                      //                     flex: 2,
                      //                     child: Column(
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.end,
                      //                         children: [
                      //                           Row(
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment.end,
                      //                             children: [
                      //                               Container(
                      //                                 color: Colors.red[600],
                      //                                 height: 10,
                      //                                 width: 10,
                      //                               ),
                      //                               SizedBox(
                      //                                 width: 5,
                      //                               ),
                      //                               Text("Away"),
                      //                             ],
                      //                           ),
                      //                           Text(predict!.predictions.away
                      //                                   .toString() +
                      //                               "%")
                      //                         ])),
                      //               ],
                      //             ),
                      //           ),
                      //         ]),
                      //   ),
                      // Container(
                      //     padding: EdgeInsets.only(left: 10, bottom: 10),
                      //     child: Text("Last 5 Form",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold, fontSize: 16))),

                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("H2H Last 5 Form",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))
                              ],
                            ),
                          ),
                          Container(
                            height: height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.95,
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 30,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                          flex: ((100 -
                                                                      int.parse(predict!
                                                                          .home
                                                                          .last5
                                                                          .form
                                                                          .replaceAll(
                                                                              "%",
                                                                              ""))) /
                                                                  10)
                                                              .toInt(),
                                                          child: Container(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                          )),
                                                      Expanded(
                                                          flex: (int.parse(predict!
                                                                      .home
                                                                      .last5
                                                                      .form
                                                                      .replaceAll(
                                                                          "%",
                                                                          "")) /
                                                                  10)
                                                              .toInt(),
                                                          child: Container(
                                                            color:
                                                                Constant.color2,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      AutoSizeText(
                                                                    match.home
                                                                        .name,
                                                                    maxLines: 2,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    softWrap:
                                                                        true,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    maxFontSize:
                                                                        18,
                                                                    minFontSize:
                                                                        8,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  predict!
                                                                      .home
                                                                      .last5
                                                                      .form,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                Text(
                                                                  "Form",
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          if (homeLast5Form.length > 0)
                                            Container(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.spaceAround,
                                                    children: List.generate(
                                                        homeLast5Form.length,
                                                        (index) => Row(
                                                              children: [
                                                                Container(
                                                                  width: 25,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                  ),
                                                                  color: homeLast5Form[index]
                                                                              .toLowerCase() ==
                                                                          "w"
                                                                      ? Colors
                                                                          .green
                                                                      : homeLast5Form[index].toLowerCase() ==
                                                                              "l"
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .grey,
                                                                  child: Center(
                                                                    child: Text(
                                                                        homeLast5Form[
                                                                            index]),
                                                                  ),
                                                                ),
                                                                if (index !=
                                                                    homeLast5Form
                                                                            .length -
                                                                        1)
                                                                  Icon(
                                                                    FontAwesomeIcons
                                                                        .caretRight,
                                                                    color: Constant
                                                                        .color1,
                                                                    size: 10,
                                                                  ),
                                                              ],
                                                            ))),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: Container(),
                                  // ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      AutoSizeText(
                                                                    match.away
                                                                        .name,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    softWrap:
                                                                        true,
                                                                    maxLines: 2,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    maxFontSize:
                                                                        18,
                                                                    minFontSize:
                                                                        8,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  predict!
                                                                      .away
                                                                      .last5
                                                                      .form,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                Text(
                                                                  "Form",
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 30,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                          flex: ((100 -
                                                                      int.parse(predict!
                                                                          .away
                                                                          .last5
                                                                          .form
                                                                          .replaceAll(
                                                                              "%",
                                                                              ""))) /
                                                                  10)
                                                              .toInt(),
                                                          child: Container(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                          )),
                                                      Expanded(
                                                          flex: (int.parse(predict!
                                                                      .away
                                                                      .last5
                                                                      .form
                                                                      .replaceAll(
                                                                          "%",
                                                                          "")) /
                                                                  10)
                                                              .toInt(),
                                                          child: Container(
                                                            color:
                                                                Constant.color1,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: List.generate(
                                                      awayLast5Form.length,
                                                      (index) => Row(
                                                            children: [
                                                              if (index != 0)
                                                                Icon(
                                                                  FontAwesomeIcons
                                                                      .caretRight,
                                                                  color: Constant
                                                                      .color1,
                                                                  size: 10,
                                                                ),
                                                              Container(
                                                                width: 25,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal: 1,
                                                                ),
                                                                color: awayLast5Form[index]
                                                                            .toLowerCase() ==
                                                                        "w"
                                                                    ? Colors
                                                                        .green
                                                                    : awayLast5Form[index].toLowerCase() ==
                                                                            "l"
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .grey,
                                                                child: Center(
                                                                  child: Text(
                                                                      awayLast5Form[
                                                                          index]),
                                                                ),
                                                              ),
                                                            ],
                                                          ))),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          )
                        ],
                      ),
                      if (h2hSummary.length > 0)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text("H2H Summary",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16))
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.white, width: 0.3)),
                              child:

//                             Column(children: [
//                               if(h2hSummary['Last 5'] != null)
//                               Column(children: [
//                                 h2hSummarySeperator("Last 5"),
//                                 H2HSummary(
//                                     matches: h2hSummary['Last 5']!,
//                                   );

//                               ],),
//                               if(h2hSummary["Overall"] != null)
//                               Column(children: [
// h2hSummarySeperator("Overall"),

// H2HSummary(
//                                     matches: h2hSummary['Overall']!,
//                                   )
//                               ],)
//                             ],),

                                  GroupedListView<List<FootballMatch>, String>(
                                      physics: NeverScrollableScrollPhysics(),
                                      addAutomaticKeepAlives: false,
                                      shrinkWrap: true,
                                      elements: h2hSummary.entries
                                          .map((e) => e.value)
                                          .toList(),
                                      groupBy: (match) =>
                                          h2hSummary["Last 5"] == match
                                              ? "Last 5"
                                              : "Overall",
                                      reverse: true,
                                      sort: true,
                                      groupSeparatorBuilder: (String name) {
                                        return h2hSummarySeperator(name);
                                      },
                                      indexedItemBuilder: (context,
                                          List<FootballMatch> matches,
                                          int index) {
                                        return H2HSummary(
                                          matches: matches,
                                          match: match,
                                        );
                                      }),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              height: 25,
                              child: Row(children: [
                                Container(
                                  width: 20,
                                  color: Constant.color2,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  match.home.name,
                                  style: TextStyle(fontSize: 10),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 20,
                                  color: Constant.color1,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  match.away.name,
                                  style: TextStyle(fontSize: 10),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Draw ",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ]),
                            )
                          ],
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10, bottom: 10),
                          child: Text("H2H list",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child:

                            // Column(
                            //     children:

                            //         //  (index) {
                            //         //   FootballMatch match = predict!.h2h[index];

                            //         //   return Container(
                            //         //     height: height * 0.2,
                            //         //     child: FootballMatchListTile(
                            //         //       key: ValueKey(match.fixture.id),
                            //         //       footballMatch: match,
                            //         //       isIncoming: true,
                            //         //       live: false,
                            //         //     ),
                            //         //   );
                            //         // }
                            //         List.generate(predict!.h2h.length, (index) {
                            //   FootballMatch match = predict!.h2h[index];

                            //   return Container(
                            //     // height: height * 0.2,
                            //     child: H2HListtile(
                            //       key: ValueKey(match.fixture.id),
                            //       footballMatch: match,

                            //     ),
                            //   );
                            // })),

                            GroupedListView<FootballMatch, String>(
                                physics: NeverScrollableScrollPhysics(),
                                addAutomaticKeepAlives: false,
                                shrinkWrap: true,
                                itemComparator: (item1, item2) =>
                                    DateTime.parse(item1.fixture.date)
                                        .toLocal()
                                        .compareTo(
                                            DateTime.parse(item2.fixture.date)
                                                .toLocal()),
                                elements: predict!.h2h,
                                groupBy: (match) =>
                                    match.league!.name +
                                    " " +
                                    match.league!.seasons.toString(),
                                groupComparator: (first, second) {
                                  return first
                                      .split(" ")
                                      .last
                                      .compareTo(second.split(" ").last);
                                },
                                reverse: true,
                                sort: true,
                                groupSeparatorBuilder: (String name) {
                                  final FootballMatch? match = predict!.h2h
                                      .firstWhereOrNull((element) =>
                                          element.league!.name +
                                              " " +
                                              element.league!.seasons
                                                  .toString() ==
                                          name);
                                  return seperator(match, name);
                                },
                                indexedItemBuilder:
                                    (context, FootballMatch match, int index) {
                                  return H2HListtile(
                                    key: ValueKey(match.fixture.id),
                                    footballMatch: match,
                                  );
                                }),
                      )
                      // Column(children:
                      //   List.generate( 7, (index) {
                      //     Predict.
                      //     return
                      //   })
                      // )
                    ],
                  ),
                );
              } else {
                return Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: NoDataWidget());
              }

              // return Column(children: [
            } else {
              return Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: NoDataWidget());
            }

            // ],);
          }
        },
      ),
    );
  }

  // Widget comparisonListTile(){
  //   return Container()
  // }

  Widget seperator(FootballMatch? match, String name) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (match != null)
              Stack(children: [
                Container(
                  width: 36.0,
                  height: 36.0,
                  color: Colors.white,
                ),
                FittedBox(
                  fit: BoxFit.fill,
                  child: Image.network(
                    match.league!.logo!,
                    width: 36.0,
                    height: 36.0,
                  ),
                ),
              ]),
            if (match != null)
              SizedBox(
                width: 8,
              ),
            // FittedBox(
            //   fit: BoxFit.fitWidth,
            //   child: Container(
            //     constraints: BoxConstraints(
            //         maxWidth: MediaQuery.of(context).size.width * 0.75),
            //     child: AutoSizeText(
            //       name,
            //       minFontSize: 5,
            //       wrapWords: false,
            //       maxLines: 2,
            //       overflow: TextOverflow.ellipsis,
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    match!.league!.name +
                        " (" +
                        match.league!.seasons.toString() +
                        ")",
                    minFontSize: 5,
                    wrapWords: false,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  AutoSizeText(
                    match.league!.country!,
                    minFontSize: 5,
                    wrapWords: false,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget h2hSummarySeperator(String name) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white, width: 0.3))),
      child: Center(
          child: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
    );
  }
}
