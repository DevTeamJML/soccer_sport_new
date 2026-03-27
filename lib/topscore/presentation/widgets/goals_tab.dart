import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/error_widget.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/entities/standing.dart';
import 'package:soccer_sport/standings/presentation/bloc/standing_bloc.dart';
import 'package:soccer_sport/topscore/domain/entities/top_score.dart';
import 'package:soccer_sport/topscore/presentation/bloc/top_score_bloc.dart';

import '../../../injection_container.dart';

class GoalsTabView extends StatefulWidget {
  final List<TopScore> topScores;
  GoalsTabView({
    required this.topScores,
  });

  @override
  State<GoalsTabView> createState() => _GoalsTabViewState();
}

class _GoalsTabViewState extends State<GoalsTabView>
    with AutomaticKeepAliveClientMixin<GoalsTabView> {
  final TopScoreBloc _topScoreBloc = serviceLocator<TopScoreBloc>();

  final _key1 = GlobalKey();

  @override
  void initState() {
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   ShowCaseWidget.of(context).startShowCase([
    //     _key1,
    //     Constant.statsFixturesKey,
    //   ]);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return

        // Showcase(
        //   key: _key1,
        //   description:
        //       "Users can see each team's total score in the selected's league in this 'Goal' section.",
        //   child:

        widget.topScores.isNotEmpty
            ? ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: widget.topScores.length + 1,
                itemBuilder: (context, index) {
                  // League
                  if (index == 0) {
                    return Container(
                      color: Constant.color2,
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text('Player',
                                        style:
                                            TextStyle(color: Colors.black)))),
                            Expanded(
                                flex: 1,
                                child: Text('Team',
                                    style: TextStyle(color: Colors.black))),
                            Expanded(
                                flex: 1,
                                child: Center(
                                    child: Text('Goals',
                                        style:
                                            TextStyle(color: Colors.black)))),
                          ],
                        ),
                      ),
                    );
                  } else {
                    TopScore topScore = widget.topScores[index - 1];
                    return Card(
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Row(children: [
                                  Text((index).toString(),
                                      style: TextStyle(color: Colors.black)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Text(topScore.player.name,
                                          style:
                                              TextStyle(color: Colors.black)))
                                ])),
                            Expanded(
                                flex: 2,
                                child: Text(topScore.statistic.team!.name!,
                                    style: TextStyle(color: Colors.black))),
                            // Expanded(
                            //     flex: 2,
                            //     child: Row(
                            //       children: [
                            //         Expanded(
                            //           flex: 1,
                            //           child: Image.network(
                            //             standing.team.logoUrl,
                            //             height: MediaQuery.of(context)
                            //                     .size
                            //                     .height *
                            //                 0.05,
                            //           ),
                            //         ),
                            //         SizedBox(
                            //           width: 5,
                            //         ),
                            //         Expanded(
                            //             flex: 5,
                            //             child: Text(standing.team.name)),
                            //       ],
                            //     )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                    topScore.statistic.goals!.total.toString(),
                                    style: TextStyle(color: Colors.black))),
                          ],
                        ),
                      ),
                    );
                  }
                })
            : NoDataWidget();
    // );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
