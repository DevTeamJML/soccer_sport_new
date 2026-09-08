import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/league/presentation/widget/league_tables_tab.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/presentation/bloc/standing_bloc.dart';

class FootballMatchStanding extends StatefulWidget {
  final FootballMatch match;
  const FootballMatchStanding({required this.match});

  @override
  State<FootballMatchStanding> createState() => _FootballMatchStandingState();
}

class _FootballMatchStandingState extends State<FootballMatchStanding> {
  final StandingBloc _standingBloc = serviceLocator<StandingBloc>();
  late FootballMatch match;
  LeagueStandings? standings;
  String? selection;
  @override
  void initState() {
    // TODO: implement initState
    match = widget.match;
    _standingBloc.add(GetStandingsByLeagueRequest(
        id: match.league!.id.toString(), season: match.league!.seasons!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _standingBloc,
      child: BlocListener<StandingBloc, StandingState>(
          bloc: _standingBloc,
          listener: (context, state) {
            if (state is StandingsLoaded) {
              setState(() {
                standings = state.standings;
              });
            }
          },
          child: BlocBuilder<StandingBloc, StandingState>(
            builder: (context, state) {
              if (state is LoadStandings) {
                return Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: double.infinity,
                    child: LoadingWidget());
              } else if (state is StandingsError) {
                return Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: double.infinity,
                    child: ErrorWidget(state.message));
              } else {
                if (standings != null) {
                  return Container(
                    height: ((MediaQuery.of(context).size.height * 0.05) *
                        (standings!.standings.length + 1)),
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    child: ListView(
                      children: [
                        Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (selection != null) {
                                          selection = null;
                                        }
                                      });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                          border: Border.all(
                                              color: Colors.white, width: 0.5),
                                          color: selection == null
                                              ? Colors.white
                                              : Colors.transparent,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),
                                        child: Center(
                                            child: Text(
                                          "All",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selection == null
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        )))),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (selection != 'home') {
                                          selection = 'home';
                                        }
                                      });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                          border: Border.all(
                                              color: Colors.white, width: 0.5),
                                          color: selection == "home"
                                              ? Colors.white
                                              : Colors.transparent,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),
                                        child: Center(
                                            child: Text(
                                          "Home",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selection == "home"
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        )))),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (selection != 'away') {
                                          selection = 'away';
                                        }
                                      });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                          border: Border.all(
                                              color: Colors.white, width: 0.5),
                                          color: selection == "away"
                                              ? Colors.white
                                              : Colors.transparent,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),
                                        child: Center(
                                            child: Text(
                                          "Away",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selection == "away"
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        )))),
                              ],
                            )),
                        Container(
                          height: ((MediaQuery.of(context).size.height * 0.05) *
                              (standings!.standings.length + 1)),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              border:
                                  Border.all(color: Colors.white, width: 0.5)),
                          child: LeagueTablesTab(
                            standings: standings!,
                            selection: selection,
                            match: match,
                            // ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: NoDataWidget());
                }
              }
            },
          )),
    );
  }
}
