import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/error_widget.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/bet_list_tile.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_date_seperator.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_list_tile.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/statistics_button.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:wordpress_api/wordpress_api.dart';
import '../../../core/constant/analytics_service.dart';
import '../../../injection_container.dart';

class BetList extends StatefulWidget {
  final int id;
  BetList({required this.id});
  @override
  State<BetList> createState() => _BetListState();
}

class _BetListState extends State<BetList> {
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();
  List<Bet> betList = [];
  @override
  void initState() {
    // TODO: implement initState

    if (Constant.auth != null)
      _footballMatchBloc
          .add(GetBetLogRequest(id: Constant.auth!.id.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Constant.auth != null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: BlocProvider(
          create: (_) => _footballMatchBloc,
          child: BlocListener<FootballMatchBloc, FootballMatchState>(
            listener: (context, state) {
              if (state is BetLogGet) {
                setState(() {
                  Constant.betList = state.bet;
                  List<Bet> list = [...state.bet[0], ...state.bet[1]];

                  betList = list
                      .where((element) => element.lId == widget.id)
                      .toList();
                });
              }
            },
            child: BlocBuilder<FootballMatchBloc, FootballMatchState>(
              builder: (context, state) {
                if (state is GettingBetLog) {
                  return LoadingWidget();
                } else if (state is FootballMatchesError) {
                  return ErrorsWidget();
                } else {
                  if (betList.length > 0) {
                    return GroupedListView<Bet, String>(
                        addAutomaticKeepAlives: false,
                        shrinkWrap: true,
                        order: GroupedListOrder.DESC,
                        itemComparator: (item1, item2) =>
                            item1.date.compareTo(item2.date),
                        elements: betList,
                        groupBy: (match) =>
                            Constant.formattedDate((match.date.toLocal())),
                        groupSeparatorBuilder: (String date) =>
                            FootballMatchDateSeperator(
                              date: date,
                            ),
                        indexedItemBuilder: (context, Bet bet, int index) {
                          // FootballMatch? liveMatch = liveMatches.firstWhereOrNull(
                          //     (v) => v.fixture.id == match.fixture.id);
                          return BetListTile(
                            bet: bet,
                          );
                        });
                  } else {
                    return Center(child: Text("Haven't bet a match yet."));
                  }
                }
              },
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('User required to login to see bet log.'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Constant.color2,
              ),
              child: Center(
                  child: Text(
                'Login',
                style: TextStyle(color: Colors.black),
              )),
            ),
          )
        ]),
      );
    }
  }
}
