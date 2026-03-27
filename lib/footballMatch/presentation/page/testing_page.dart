import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/error_widget.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_date_seperator.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_list_tile.dart';

import '../../../injection_container.dart';

class TestingPage extends StatefulWidget {
  TestingPage({Key? key}) : super(key: key);

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  List<FootballMatch> footballMatches = [];
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();

  void initState() {
    super.initState();
    _footballMatchBloc.add(GetAllMatchRequest());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _footballMatchBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FootballMatchBloc>(
      create: (_) => _footballMatchBloc,
      child: BlocListener<FootballMatchBloc, FootballMatchState>(
        listener: (context, state) {
          if (state is FootballMatchesLoaded) {
            footballMatches = state.footballMatches;
          }
        },
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
                          return Expanded(
                            child:
                                // ListView.builder(
                                //   itemCount: footballMatches.length,
                                //   itemBuilder: (context, index) {
                                //     return FootballMatchListTile(
                                //         footballMatch: footballMatches[index]);
                                //   },
                                // ),
                                //     GroupedListView<FootballMatch, String>(
                                //   shrinkWrap: true,
                                //   order: GroupedListOrder.DESC,
                                //   elements: footballMatches,
                                //   groupBy: (match) => Constant.formattedDate(
                                //       (DateTime.parse(match.fixture.date)
                                //           .toLocal())),
                                //   groupSeparatorBuilder: (String date) =>
                                //       FootballMatchDateSeperator(
                                //     date: date,
                                //   ),
                                //   itemBuilder: (context, FootballMatch match) =>
                                //       FootballMatchListTile(
                                //     footballMatch: match,
                                //     isIncoming: false,
                                //   ),
                                // ),
                                GroupedListView<FootballMatch, String>(
                              shrinkWrap: true,
                              order: GroupedListOrder.DESC,
                              elements: footballMatches,
                              groupBy: (match) {
                                return Constant.formattedDate(
                                    (DateTime.parse(match.fixture.date)
                                        .toLocal()));
                              },
                              groupSeparatorBuilder: (String date) =>
                                  FootballMatchDateSeperator(
                                date: date,
                              ),
                              itemBuilder: (context, FootballMatch match) =>
                                  FootballMatchListTile(
                                key: ValueKey(match.fixture.id),
                                live: false,
                                footballMatch: match,
                                isIncoming: false,
                              ),
                            ),
                          );
                        } else {
                          return NoDataWidget();
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
