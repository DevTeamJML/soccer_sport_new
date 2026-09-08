import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_stats_info.dart';
import 'dart:math' as math;

import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/injection_container.dart';

class FootballMatchStatsWidget extends StatefulWidget {
  // final List<MatchStatsInfo> matchStats;
  final FootballMatch match;
  const FootballMatchStatsWidget({
    required this.match,
  });

  @override
  State<FootballMatchStatsWidget> createState() =>
      _FootballMatchStatsWidgetState();
}

class _FootballMatchStatsWidgetState extends State<FootballMatchStatsWidget> {
  MatchStatsInfo? homeMatchStats;
  MatchStatsInfo? awayMatchStats;
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();
  @override
  void initState() {
    _footballMatchBloc
        .add(GetMatchStatsInfoRequest(id: widget.match.fixture.id.toString()));
    // homeMatchStats = widget.matchStats
    //     .firstWhere((element) => element.team.id == widget.match.home.id);
    // awayMatchStats = widget.matchStats
    //     .firstWhere((element) => element.team.id == widget.match.away.id);

    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _footballMatchBloc,
      child: BlocListener<FootballMatchBloc, FootballMatchState>(
        listener: (context, state) {
          if (state is MatchStatsInfoGet) {
            setState(() {
              homeMatchStats = state.stats.firstWhere(
                  (element) => element.team.id == widget.match.home.id);
              awayMatchStats = state.stats.firstWhere(
                  (element) => element.team.id == widget.match.away.id);
            });
          }
        },
        child: BlocBuilder<FootballMatchBloc, FootballMatchState>(
          builder: (context, state) {
            if (state is GettingMatchStatsInfo) {
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
              if (homeMatchStats != null && awayMatchStats != null) {
                // return Container(
                //   height: (homeMatchStats!.statsInfo.length *
                //           (MediaQuery.of(context).size.height * 0.8)) +
                //       MediaQuery.of(context).padding.bottom,
                //   child: Column(
                //       children:
                //           homeMatchStats!.statsInfo.asMap().entries.map((e) {
                //     int totalAmount = homeMatchStats!.statsInfo[e.key].value +
                //         awayMatchStats!.statsInfo[e.key].value;

                //     return Container(
                //       height: MediaQuery.of(context).size.height * 0.06,
                //       width: MediaQuery.of(context).size.width,
                //       padding: EdgeInsets.all(5),
                //       child: Column(children: [
                //         Expanded(
                //           child: Row(
                //             children: [
                //               Expanded(
                //                 child: Row(children: [
                //                   Text(homeMatchStats!.statsInfo[e.key].value
                //                       .toString()),
                //                 ]),
                //               ),
                //               Text(homeMatchStats!.statsInfo[e.key].type),
                //               Expanded(
                //                 child: Row(children: [
                //                   Text(awayMatchStats!.statsInfo[e.key].value
                //                       .toString()),
                //                 ]),
                //               ),
                //             ],
                //           ),
                //         ),
                //         Expanded(
                //           child: Row(
                //             children: [
                //               Expanded(
                //                 child: Container(
                //                   height: double.infinity,
                //                   child: Transform(
                //                     alignment: Alignment.center,
                //                     transform: Matrix4.rotationY(math.pi),
                //                     child: LinearProgressIndicator(
                //                       minHeight: 10,
                //                       value: totalAmount != 0
                //                           ? homeMatchStats!
                //                                   .statsInfo[e.key].value /
                //                               totalAmount
                //                           : 0.0,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               SizedBox(
                //                 width: 10,
                //               ),
                //               Expanded(
                //                   child: Container(
                //                 height: double.infinity,
                //                 child: LinearProgressIndicator(
                //                   minHeight: 10,
                //                   value: totalAmount != 0
                //                       ? awayMatchStats!.statsInfo[e.key].value /
                //                           totalAmount
                //                       : 0.0,
                //                 ),
                //               ))
                //             ],
                //           ),
                //         )
                //       ]),
                //     );
                //   }).toList()),
                // );

                return Padding(
                  padding: EdgeInsets.only(
                      right: 10.0,
                      left: 10,
                      top: 10,
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: homeMatchStats!.statsInfo.length,
                    itemBuilder: (context, index) {
                      int totalAmount = homeMatchStats!.statsInfo[index].value +
                          awayMatchStats!.statsInfo[index].value;
                      if (homeMatchStats!.statsInfo.length == index + 1 &&
                          homeMatchStats!.statsInfo.last.type ==
                              "expected_goals") {
                        return Container();
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(5),
                          child: Column(children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(children: [
                                      Text(homeMatchStats!
                                          .statsInfo[index].value
                                          .toString()),
                                    ]),
                                  ),
                                  Text(homeMatchStats!.statsInfo[index].type),
                                  Expanded(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(awayMatchStats!
                                              .statsInfo[index].value
                                              .toString()),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: double.infinity,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: LinearProgressIndicator(
                                        minHeight: 7,
                                        value: totalAmount != 0
                                            ? homeMatchStats!
                                                    .statsInfo[index].value /
                                                totalAmount
                                            : 0.0,
                                        backgroundColor: totalAmount == 0
                                            ? Colors.grey
                                            : Colors.red[700],
                                        // color: totalAmount != 0
                                        //     ? ((homeMatchStats!.statsInfo[index]
                                        //                     .value /
                                        //                 totalAmount) >
                                        //             (awayMatchStats!
                                        //                     .statsInfo[index]
                                        //                     .value /
                                        //                 totalAmount)
                                        //         ? Constant.color2
                                        //         : Colors.grey)
                                        //     : Constant.color1,
                                        color: Constant.color2,
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: Container(
                                  //     height: double.infinity,
                                  //     padding: EdgeInsets.symmetric(vertical: 5),
                                  //     child: Transform(
                                  //       alignment: Alignment.center,
                                  //       transform: Matrix4.rotationY(math.pi),
                                  //       child: LinearProgressIndicator(
                                  //         minHeight: 7,
                                  //         value: totalAmount != 0
                                  //             ? homeMatchStats!
                                  //                     .statsInfo[index].value /
                                  //                 totalAmount
                                  //             : 0.0,
                                  //         backgroundColor: Colors.grey[800],
                                  //         color: totalAmount != 0
                                  //             ? ((homeMatchStats!.statsInfo[index]
                                  //                             .value /
                                  //                         totalAmount) >
                                  //                     (awayMatchStats!
                                  //                             .statsInfo[index]
                                  //                             .value /
                                  //                         totalAmount)
                                  //                 ? Constant.color2
                                  //                 : Colors.grey)
                                  //             : Constant.color1,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  // Expanded(
                                  //     child: Container(
                                  //   height: double.infinity,
                                  //   padding: EdgeInsets.symmetric(vertical: 5),
                                  //   child: LinearProgressIndicator(
                                  //     minHeight: 7,
                                  //     value: totalAmount != 0
                                  //         ? awayMatchStats!
                                  //                 .statsInfo[index].value /
                                  //             totalAmount
                                  //         : 0.0,
                                  //     backgroundColor: Colors.grey[800],
                                  //     color: totalAmount != 0
                                  //         ? ((awayMatchStats!.statsInfo[index]
                                  //                         .value /
                                  //                     totalAmount) >
                                  //                 (homeMatchStats!
                                  //                         .statsInfo[index]
                                  //                         .value /
                                  //                     totalAmount)
                                  //             ? Constant.color2
                                  //             : Colors.grey)
                                  //         : Constant.color1,
                                  //   ),
                                  // ))
                                ],
                              ),
                            )
                          ]),
                        );
                      }
                    },
                  ),
                );
              } else {
                return Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        border: Border.all(color: Colors.white, width: 0.5)),
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Center(
                      child: Text("Stats will display here as they happen"),
                    ));
              }
            }
          },
        ),
      ),
    );
  }
}
