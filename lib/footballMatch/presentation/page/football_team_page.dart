import 'dart:async';

import 'package:advance_notification/advance_notification.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/team_info/team_matches_info.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/team_info/team_stats_info.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/constant/constants.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../favourite/presentation/bloc/favourite_bloc.dart';
import '../../../injection_container.dart';
import '../../../league/domain/entities/league.dart';
import '../../domain/entities/football_match.dart';
import '../../domain/entities/team.dart';
import '../bloc/football_match_bloc.dart';
import '../widget/team_info/team_tables_info.dart';

class FootballTeamPage extends StatefulWidget {
  final Team team;
  final League league;
  const FootballTeamPage({required this.team, required this.league});

  @override
  State<FootballTeamPage> createState() => _FootballTeamPageState();
}

class _FootballTeamPageState extends State<FootballTeamPage>
    with SingleTickerProviderStateMixin {
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();
  final FavouriteBloc _favouriteBloc = serviceLocator<FavouriteBloc>();
  List<FootballMatch> matchList = [];
  late List<Team> favouriteTeam = [];

  bool fixedScroll = false;
  late ScrollController _scrollController;
  late TabController _tabController;
  List<String> listOfLeagueName = [];
  List<League> listOfLeague = [];
  List<FootballMatch> lives = [];
  bool isFavourite = false;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _tabController = new TabController(
      vsync: this,
      length: 3,
    );

    _favouriteBloc.add(GetFavouriteTeamRequestV2());

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      _smoothScrollToTop();
    });
    _footballMatchBloc.add(GetFixtureByTeamRequest(
        id: widget.team.id.toString(),
        season: widget.league.seasons.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => _footballMatchBloc,
            ),
            BlocProvider(
              create: (context) => _favouriteBloc,
            ),
            //       BlocProvider(
            //   create: (context) => _favoriteMatchBloc,
            // ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<FootballMatchBloc, FootballMatchState>(
                bloc: _footballMatchBloc,
                listener: (context, state) {
                  if (state is FixturesByTeamLoaded) {
                    setState(() {
                      matchList = state.match;
                      listOfLeagueName =
                          matchList.map((e) => e.league!.name).toSet().toList();

                      listOfLeague = listOfLeagueName
                          .map((e) => (matchList
                              .firstWhere(
                                  (element) => e == element.league!.name)
                              .league!))
                          .toList();
                    });
                  }
                },
              ),
              BlocListener<FavouriteBloc, FavouriteState>(
                bloc: _favouriteBloc,
                listener: (context, state) {
                  if (state is FavouriteTeamV2Loaded) {
                    setState(() {
                      favouriteTeam = state.teams;
                      isFavourite = favouriteTeam.firstWhereOrNull(
                              (element) => element.id == widget.team.id) !=
                          null;
                    });
                  }
                  if (state is FavouriteTeamV2Persisted) {
                    if (state.teams) {
                      _favouriteBloc.add(GetFavouriteTeamRequestV2());
                      // ScaffoldMessenger.of(context).clearSnackBars();
                      // Timer(const Duration(milliseconds: 100), () {
                      //   AdvanceSnackBar(
                      //           mode: Mode.ADVANCE,
                      //           message:
                      //               "${widget.team.name} has added in favourite list.",
                      //           bgColor: Colors.green)
                      //       .show(context);
                      // });
                      Flushbar(
                        backgroundColor: Colors.green,
                        mainButton: Icon(FontAwesomeIcons.circleXmark,
                            color: Colors.white),
                        onTap: (v) {
                          v.dismiss(true);
                        },
                        message: "${widget.team.name} has added in favourite.",
                        margin: EdgeInsets.fromLTRB(8, kToolbarHeight, 8, 8),
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }
                  }

                  if (state is FavouriteTeamV2Removed) {
                    if (state.teams) {
                      _favouriteBloc.add(GetFavouriteTeamRequestV2());
                      Flushbar(
                        // title:  "Hey Ninja",
                        backgroundColor: Constant.color1,
                        mainButton: Icon(FontAwesomeIcons.circleXmark,
                            color: Colors.white),
                        onTap: (v) {
                          v.dismiss(true);
                        },
                        message: "This match has removed from favourite.",
                        margin: EdgeInsets.fromLTRB(8, kToolbarHeight, 8, 8),
                        duration: Duration(seconds: 3),
                      )..show(context);

                      // Flushbar(
                      //   // title:  "Hey Ninja",
                      //   icon: Container(
                      //     color: Colors.white,
                      //     height: 30,
                      //     width: 30,
                      //     margin: EdgeInsets.only(right: 10),
                      //     child: FadeInImage.memoryNetwork(
                      //         placeholder: kTransparentImage,
                      //         image: widget.team.logoUrl,
                      //         imageErrorBuilder: (e, o, c) {
                      //           return Container();
                      //         }),
                      //   ),
                      //   backgroundColor: Constant.color1,
                      //   mainButton: Icon(FontAwesomeIcons.circleXmark,
                      //       color: Colors.white),
                      //   onTap: (v) {
                      //     v.dismiss(true);
                      //   },
                      //   message:
                      //       "${widget.team.name} has removed from favourite list.",
                      //   duration: Duration(seconds: 3),
                      // )..show(context);
                    }
                  }
                },
              )
            ],
            child: StreamBuilder<List<FootballMatch>>(
                stream: Constant.liveData.stream,
                builder: (context, snapshot) {
                  lives = snapshot.data != null ? snapshot.data! : [];

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, value) {
                        return [
                          SliverToBoxAdapter(
                              child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.065,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      height: 30,
                                      width: 30,
                                      margin: EdgeInsets.only(right: 10),
                                      child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: widget.team.logoUrl,
                                          imageErrorBuilder: (e, o, c) {
                                            return Container();
                                          }),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.team.name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  widget.league.country ?? "",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isFavourite) {
                                            _favouriteBloc.add(
                                                RemoveFavouriteTeamRequestV2(
                                              teams: widget.team,
                                            ));
                                          } else {
                                            _favouriteBloc.add(
                                                PersistFavouriteTeamRequestV2(
                                                    teams: widget.team));
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        child: Icon(
                                          isFavourite
                                              ? Icons.star
                                              : Icons.star_border_outlined,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                          SliverToBoxAdapter(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Colors.white,
                                width: 0.8,
                              ))),
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: double.infinity,
                              child: TabBar(
                                  controller: _tabController,
                                  isScrollable: true,
                                  indicatorColor: Colors.transparent,
                                  tabs: [
                                    Tab(
                                        icon: Text('Matches',
                                            style: TextStyle(
                                                color: Colors.white))),
                                    Tab(
                                        icon: Text('Tables',
                                            style: TextStyle(
                                                color: Colors.white))),
                                    Tab(
                                        icon: Text('Stats',
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ]),
                            ),
                          ),
                        ];
                      },
                      body: BlocBuilder<FootballMatchBloc, FootballMatchState>(
                        builder: (context, state) {
                          if (state is LoadFixturesByTeam) {
                            return LoadingWidget();
                          } else if (state is FootballMatchesError) {
                            return ErrorWidget(state.message);
                          } else {
                            return TabBarView(
                              // physics: NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: [
                                TeamMatchesInfo(
                                  matchList: matchList,
                                  listOfLeague: listOfLeagueName,
                                ),
                                TeamTablesInfo(
                                  team: widget.team,
                                  league: widget.league,
                                ),
                                TeamStatsInfo(
                                  team: widget.team,
                                  league: widget.league,
                                ),
                                // FootballMatchLineupsWidget(
                                //   match: match,
                                //   bloc: _footballMatchBloc,
                                //   events: events,
                                // ),
                                // Container(
                                //   child: FootballMatchStanding(
                                //     match: match,
                                //   ),
                                // )
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  );
                }),
          ),
        ));
  }

  _scrollListener() {
    if (fixedScroll) {
      _scrollController.jumpTo(0);
    }
  }

  _smoothScrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300), 
        curve: Curves.ease,
      );
    }
    // _scrollController.animateTo(
    //   0,
    //   duration: Duration(microseconds: 300),
    //   curve: Curves.ease,
    // );

    setState(() {
      fixedScroll = _tabController.index == 2 || _tabController.index == 1;
    });
  }

  showSnackbar(Team team, bool isFavourie) {
    Flushbar(
      // title:  "Hey Ninja",
      icon: Container(
        color: Colors.white,
        height: 30,
        width: 30,
        margin: EdgeInsets.only(right: 10),
        child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.team.logoUrl,
            imageErrorBuilder: (e, o, c) {
              return Container();
            }),
      ),
      backgroundColor: Colors.green,
      mainButton: Icon(Icons.close, color: Colors.white),
      onTap: (v) {
        v.dismiss(true);
      },
      message: "${widget.team.name} has added in favourite list.",
      margin: EdgeInsets.fromLTRB(8, kToolbarHeight, 8, 8),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
