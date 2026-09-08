import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/error_widget.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/usecases/get_league_by_name.dart';
import 'package:soccer_sport/league/presentation/bloc/league_bloc.dart';
import 'package:soccer_sport/league/presentation/widget/league_fixtures_tab.dart';
import 'package:soccer_sport/league/presentation/widget/league_tables_tab.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/entities/standing.dart';
import 'package:soccer_sport/standings/presentation/bloc/standing_bloc.dart';
import 'package:soccer_sport/topscore/domain/entities/top_score.dart';
import 'package:soccer_sport/topscore/presentation/bloc/top_score_bloc.dart';
import 'package:soccer_sport/topscore/presentation/widgets/goals_tab.dart';

import '../../../injection_container.dart';

class LeagueView extends StatefulWidget {
  final LeagueDetails leagueDetails;
  // LeagueDetails league;
  LeagueView({
    required this.leagueDetails,
  });

  @override
  _LeagueViewState createState() => _LeagueViewState();
}

class _LeagueViewState extends State<LeagueView>
    with SingleTickerProviderStateMixin {
  @override
  // LeagueStandings? standings;
  final LeagueBloc _leagueBloc = serviceLocator<LeagueBloc>();
  //  LeagueBloc _leagueBloc = BlocProvider.of<SettingBloc>(context);
// BlocProvider.of<LeagueBloc>(context);
  final season = ValueNotifier<String>('');
  LeagueStandings? standings;
  List<TopScore>? topScores;
  late int index;
  late TabController _tabController;
  final StandingBloc _standingBloc = serviceLocator<StandingBloc>();
  final TopScoreBloc _topScoreBloc = serviceLocator<TopScoreBloc>();

//fixture data
  List<String> fixtureRounds = [];
  List<FootballMatch> footballMatch = [];
  String currentRound = '';
  String liveRound = '';
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();
  final _key1 = GlobalKey();

  final _key2 = GlobalKey();
  final _key3 = GlobalKey();

  final _key4 = GlobalKey();

  @override
  void didChangeDependencies() {
    print('did change depednd xxx');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _footballMatchBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    print(widget.leagueDetails.league.id);

    _tabController = new TabController(
      vsync: this,
      length: 3,
    );
    season.value = widget.leagueDetails.seasons!.last.year.toString();
    index = widget.leagueDetails.seasons!.length;
    _standingBloc.add(GetStandingsByLeagueRequest(
        id: widget.leagueDetails.league.id.toString(),
        season: int.parse(season.value)));
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        switch (_tabController.index) {
          case 0:
            _standingBloc.add(GetStandingsByLeagueRequest(
                id: widget.leagueDetails.league.id.toString(),
                season: int.parse(season.value)));
            serviceLocator<AnalyticsService>().logScreens(
                name: '/statsPage/' +
                    widget.leagueDetails.league.name +
                    '/table');
            break;
          case 1:
            _topScoreBloc.add(GetTopScoresByLeagueRequest(
                id: widget.leagueDetails.league.id.toString(),
                season: season.value));
            serviceLocator<AnalyticsService>().logScreens(
                name: '/statsPage/' +
                    widget.leagueDetails.league.name +
                    '/goals');
            break;
          case 2:
            if (liveRound != '') {
              _footballMatchBloc.add(GetFixtureByRoundRequest(
                  round: currentRound,
                  leagueId: widget.leagueDetails.league.id.toString(),
                  season: season.value));
            } else {
              _footballMatchBloc.add(GetFixtureRoundRequest(
                  leagueId: widget.leagueDetails.league.id.toString(),
                  season: season.value));
            }
            serviceLocator<AnalyticsService>().logScreens(
                name: '/statsPage/' +
                    widget.leagueDetails.league.name +
                    '/fixtures');
            break;
          default:
            break;
        }
      }
    });
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   if (Constant.showcaseBool)
    //     ShowCaseWidget.of(context).startShowCase([
    //       _key1,
    //       Constant.dropdownButtonKey,
    //       _key2,
    //       Constant.statsGaolsKey,
    //     ]);
    // });

    super.initState();
  }

  showPicker(
    BuildContext context,
  ) {
    Picker(
        adapter: PickerDataAdapter<String>(
          data: widget.leagueDetails.seasons != null
              ? widget.leagueDetails.seasons!
                  .map((e) => PickerItem(
                      text: Text(e.year.toString()), value: e.year.toString()))
                  .toList()
              : [],
        ),
        reversedOrder: false,
        changeToFirst: true,
        selecteds: [index],
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          setState(() {
            currentRound = '';
            liveRound = '';
            season.value = picker.getSelectedValues()[0];
            index = value.indexOf(season);
            if (_tabController.index == 0) {
              _standingBloc.add(GetStandingsByLeagueRequest(
                  id: widget.leagueDetails.league.id.toString(),
                  season: int.parse(season.value)));
            } else if (_tabController.index == 1) {
              print('got rub top score');
              _topScoreBloc.add(GetTopScoresByLeagueRequest(
                  id: widget.leagueDetails.league.id.toString(),
                  season: season.value));
            } else if (_tabController.index == 2) {
              if (liveRound != '') {
                _footballMatchBloc.add(GetFixtureByRoundRequest(
                    round: currentRound,
                    leagueId: widget.leagueDetails.league.id.toString(),
                    season: season.value));
              } else {
                print('print season' + season.value);
                _footballMatchBloc.add(GetFixtureRoundRequest(
                    leagueId: widget.leagueDetails.league.id.toString(),
                    season: season.value));
              }
            }
          });
        }).showModal(this.context);
  }

  @override
  Widget build(BuildContext context) {
    print('got rebuild');
    return BlocProvider<LeagueBloc>(
      create: (context) => _leagueBloc,
      child: BlocBuilder<LeagueBloc, LeagueState>(
        bloc: _leagueBloc,
        buildWhen: (pv, cr) {
          if (cr is SeasonLoaded) {
            print('season loaded');
          }
          return cr is SeasonLoaded;
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.white)),
                    child:

                        // Showcase(
                        //   key: _key2,
                        //   description:
                        //       "Users can change the season of the league to look different season statistic info.",
                        //   overlayPadding:
                        //       EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        //   child:

                        GestureDetector(
                            onTap: () {
                              showPicker(context);
                            },
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Season ' + season.value,
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
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      child: TabBar(controller: _tabController, tabs: [
                        Tab(
                            icon: Text(
                          'Tables',
                        )),
                        // Showcase(
                        //   key: Constant.statsGaolsKey,
                        //   description: "Click here to proceed",
                        //   onTargetClick: () {
                        //     _tabController.animateTo(1);
                        //   },
                        //   onToolTipClick: () {
                        //     _tabController.animateTo(1);
                        //   },
                        //   overlayPadding: EdgeInsets.symmetric(horizontal: 40),
                        //   disposeOnTap: true,
                        //   child:

                        Tab(
                            icon: Text(
                          'Goals',
                        )),
                        // ),
                        // Showcase(
                        //   key: Constant.statsFixturesKey,
                        //   description: "Click here to proceed",
                        //   onTargetClick: () {
                        //     _tabController.animateTo(2);
                        //   },
                        //   onToolTipClick: () {
                        //     _tabController.animateTo(2);
                        //   },
                        //   overlayPadding: EdgeInsets.symmetric(horizontal: 40),
                        //   disposeOnTap: true,
                        //   child:
                        Tab(
                            icon: Text(
                          'Fixtures',
                        )),
                        // ),
                      ]),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // table tab
                          BlocProvider<StandingBloc>(
                              create: (context) => _standingBloc,
                              child: BlocListener<StandingBloc, StandingState>(
                                bloc: _standingBloc,
                                listener: (context, state) {
                                  if (state is StandingsLoaded) {
                                    print('got loaded standing');
                                    setState(() {
                                      standings = state.standings;
                                    });
                                  }
                                },
                                child: BlocBuilder<StandingBloc, StandingState>(
                                  bloc: _standingBloc,
                                  buildWhen: (previous, current) =>
                                      current is LoadStandings ||
                                      current is StandingsLoaded ||
                                      current is StandingsError,
                                  builder: (context, state) {
                                    if (state is LoadStandings) {
                                      return LoadingWidget();
                                    } else if (state is StandingsError) {
                                      return ErrorsWidget();
                                    } else {
                                      if (standings != null) {
                                        // return RefreshIndicator(
                                        //   onRefresh: _onRefresh,
                                        //   child:
                                        // );
                                        return
                                            // Showcase(
                                            //   key: _key1,
                                            //   description:
                                            //       "Here can see league's standigs table data",
                                            //   child:
                                            LeagueTablesTab(
                                          standings: standings!,
                                          // ),
                                        );
                                      } else {
                                        return NoDataWidget();
                                      }
                                    }
                                  },
                                  // ),
                                ),
                              )),

                          // goals tab
                          BlocProvider<TopScoreBloc>(
                            create: (context) => _topScoreBloc,
                            child: BlocListener<TopScoreBloc, TopScoreState>(
                              bloc: _topScoreBloc,
                              listener: (context, state) {
                                if (state is TopScoresLoaded) {
                                  setState(() {
                                    topScores = state.topScore;
                                  });
                                }
                              },
                              child: BlocBuilder<TopScoreBloc, TopScoreState>(
                                bloc: _topScoreBloc,
                                builder: (context, state) {
                                  if (state is LoadTopScores) {
                                    return LoadingWidget();
                                  } else if (state is TopScoreError) {
                                    return ErrorsWidget();
                                  } else {
                                    if (topScores != null) {
                                      // return RefreshIndicator(
                                      //     onRefresh: _topScoreOnRefresh,
                                      //     child: );
                                      return GoalsTabView(
                                        topScores: topScores!,
                                      );
                                    } else {
                                      return NoDataWidget();
                                    }
                                  }
                                },
                              ),
                            ),
                          ),

                          //fixtures tab
                          BlocProvider<FootballMatchBloc>(
                            create: (context) => _footballMatchBloc,
                            child: BlocListener<FootballMatchBloc,
                                FootballMatchState>(
                              bloc: _footballMatchBloc,
                              listener: (context, state) {
                                if (state is FixtureRoundsLoaded) {
                                  setState(() {
                                    fixtureRounds = state.footballMatches;
                                    print('print first round' +
                                        fixtureRounds.last);
                                    _footballMatchBloc.add(
                                        GetFixturesCurrentRoundRequest(
                                            leagueId: widget
                                                .leagueDetails.league.id
                                                .toString(),
                                            season: season.value));
                                  });
                                }
                                if (state is FixturesCurrentRoundLoaded) {
                                  setState(() {
                                    print('print current round' +
                                        fixtureRounds.length.toString());
                                    liveRound = state.footballMatches;
                                    currentRound = state.footballMatches;

                                    _footballMatchBloc
                                        .add(
                                            GetFixtureByRoundRequest(
                                                round: currentRound != ''
                                                    ? currentRound
                                                    : fixtureRounds[0],
                                                leagueId: widget
                                                    .leagueDetails.league.id
                                                    .toString(),
                                                season: season.value));
                                  });
                                }
                                if (state is CurrentRoundFixturesLoaded) {
                                  setState(() {
                                    currentRound = state.currentRound;
                                    footballMatch = state.footballMatches;
                                    print(footballMatch.length);
                                  });
                                }
                              },
                              child: BlocBuilder<FootballMatchBloc,
                                  FootballMatchState>(
                                bloc: _footballMatchBloc,
                                builder: (context, state) {
                                  if (state is LoadFixtureRounds ||
                                      state is LoadCurrentRoundFixtures ||
                                      state is LoadFixturesCurrentRound) {
                                    return LoadingWidget();
                                  } else if (state is FootballMatchesError) {
                                    return ErrorsWidget();
                                  } else {
                                    // if (footballMatch.length > 0) {
                                    //   print(currentRound);
                                    //   return RefreshIndicator(
                                    //     onRefresh: _fixturesOnRefresh,
                                    //     child: LeagueFixturesTab(
                                    //       league: widget.leagueDetails,
                                    //       footballMatch: footballMatch,
                                    //       fixtureRounds: fixtureRounds,
                                    //       currentRound: currentRound,
                                    //       season: season.value,
                                    //     ),
                                    //   );
                                    // } else {
                                    //   return NoDataWidget();
                                    // }
                                    //
                                    return LeagueFixturesTab(
                                      league: widget.leagueDetails,
                                      footballMatch: footballMatch,
                                      fixtureRounds: fixtureRounds,
                                      currentRound: currentRound,
                                      season: season.value,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),

                          ///list viwewsss
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    // monitor network fetch
    _standingBloc.add(GetStandingsByLeagueRequest(
        id: widget.leagueDetails.league.id.toString(),
        season: int.parse(season.value)));
    return Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    // _refreshController.refreshCompleted();
  }

  Future<void> _topScoreOnRefresh() async {
    _topScoreBloc.add(GetTopScoresByLeagueRequest(
        id: widget.leagueDetails.league.id.toString(), season: season.value));
    return Future.delayed(Duration(milliseconds: 1000));
  }

  Future<void> _fixturesOnRefresh() async {
    if (liveRound != '') {
      _footballMatchBloc.add(GetFixtureByRoundRequest(
          round: currentRound,
          leagueId: widget.leagueDetails.league.id.toString(),
          season: season.value));
    } else {
      _footballMatchBloc.add(GetFixtureRoundRequest(
          leagueId: widget.leagueDetails.league.id.toString(),
          season: season.value));
    }
    return Future.delayed(Duration(milliseconds: 2000));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
