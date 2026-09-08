import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/team_info/player_stats_table.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/presentation/bloc/league_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../core/constant/constants.dart';
import '../../../../injection_container.dart';
import '../../../../league/domain/entities/league.dart';
import '../../../../league/domain/entities/season.dart';
import '../../../domain/entities/team.dart';
import '../../../domain/entities/team_info/player_stats_info.dart';
import '../../../domain/entities/team_info/player_stats_info_v2.dart';
import '../../bloc/football_match_bloc.dart';
import 'package:collection/collection.dart';

import 'league_dropdown_button.dart';

class TeamStatsInfo extends StatefulWidget {
  final Team team;
  final League league;

  const TeamStatsInfo({required this.team, required this.league});

  @override
  State<TeamStatsInfo> createState() => _TeamStatsInfoState();
}

class _TeamStatsInfoState extends State<TeamStatsInfo> {
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();

  final LeagueBloc _leagueBloc = serviceLocator<LeagueBloc>();
  List<LeagueDetails> leaguesSeason = [];
  List<PlayerStatsInfoV2> playerStatList = [];
  List<PlayerStatsInfoV2> filteredList = [];
  List<LeagueDetails> listOfLeagueDetail = [];

  List<PlayerStatsInfoV2> goalKeeperList = [];

  List<PlayerStatsInfoV2> filteredGoalKeeperList = [];
  List<PlayerStatsInfoV2> outfieldList = [];
  List<PlayerStatsInfoV2> filteredOutfieldList = [];
  List<String> whereListOfLeague = [];
  LeagueDetails? selectedLeague;
  Season? avaiableCoverage;

  bool seasonIsNull = false;
  @override
  void initState() {
    super.initState();

    var constantSeason = Constant.leaguesSeasonList.firstWhereOrNull(
        (element) => element[widget.team.id.toString()] != null);
    if (constantSeason != null) {
      var fetchedLeagueDetails = constantSeason[widget.team.id.toString()]!;

      addLeagueSeason(fetchedLeagueDetails);

      // leaguesSeason = constantSeason[widget.team.id.toString()]!;
      // LeagueDetails leagueDetail = leaguesSeason.reversed
      //     .firstWhere((element) => element.league.id == widget.league.id);
      // var season = leagueDetail.seasons!.reversed.firstWhereOrNull((element) {
      //   if (element.coverage != null &&
      //       element.coverage!.fixtures != null &&
      //       element.coverage!.fixtures!.statisticsPlayers != null) {
      //     return element.coverage!.fixtures!.statisticsPlayers!;
      //   } else {
      //     return false;
      //   }
      // });
      // if (season != null) {
      //   _footballMatchBloc.add(GetPlayerStatsInfoRequest(
      //       id: widget.team.id.toString(), season: season.year.toString()));
      // } else {
      //   seasonIsNull = true;
      // }
    } else {
      _leagueBloc.add(GetTeamSeasonRequest(id: widget.team.id.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _footballMatchBloc,
        ),
        BlocProvider(
          create: (context) => _leagueBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<FootballMatchBloc, FootballMatchState>(
            listener: (context, state) {
              if (state is PlayerStatsInfoLoaded) {
                setState(() {
                  playerStatList = state.match;
                  if (playerStatList.length > 0) {
                    // PlayerStatsInfo hasHighestListOfLeague =
                    //     playerStatList.reduce((a, b) =>
                    //         a.playerStats.length > b.playerStats.length
                    //             ? a
                    //             : b);

                    // listOfLeague = hasHighestListOfLeague.playerStats
                    //     .map((e) => e.league)
                    //     .toSet()
                    //     .toList();

                    // listOfLeague = listOfLeague.fold<List<League>>([], (a, b) {
                    //   if (!a.any((element) => (element.id == b.id &&
                    //       element.seasons == b.seasons))) {
                    //     return [...a, b];
                    //   }

                    //   return a;
                    // });

                    goalKeeperList = playerStatList
                        .where((e) =>
                            e.position.toLowerCase() == "goalkeeper" &&
                            (listOfLeagueDetail.firstWhereOrNull((element) {
                                  if (element.seasons != null) {
                                    int validSeason = e.season.contains("-")
                                        ? int.parse(e.season.split("-")[0])
                                        : int.tryParse(e.season) != null
                                            ? int.parse(e.season)
                                            : 0;
                                    bool isTrue = (element.league.name +
                                            " " +
                                            element.seasons![0].year
                                                .toString()) ==
                                        e.league + " " + validSeason.toString();
                                    if (isTrue) {
                                      whereListOfLeague.add(e.league +
                                          " " +
                                          validSeason.toString());
                                    }
                                    return isTrue;
                                  } else {
                                    return false;
                                  }
                                }) !=
                                null))
                        .toList();
                    outfieldList = playerStatList
                        .where((e) =>
                            e.position.toLowerCase() != "goalkeeper" &&
                            (listOfLeagueDetail.firstWhereOrNull((element) {
                                  if (element.seasons != null) {
                                    int validSeason = e.season.contains("-")
                                        ? int.parse(e.season.split("-")[0])
                                        : int.tryParse(e.season) != null
                                            ? int.parse(e.season)
                                            : 0;
                                    return (element.league.name +
                                            " " +
                                            element.seasons![0].year
                                                .toString()) ==
                                        e.league + " " + validSeason.toString();
                                  } else {
                                    return false;
                                  }
                                }) !=
                                null))
                        .toList();

                    var test = listOfLeagueDetail
                        .where((element) => whereListOfLeague
                            .toSet()
                            .toList()
                            .contains(element.league.name +
                                " " +
                                element.seasons![0].year.toString()))
                        .toList();
                    listOfLeagueDetail = test;
                    selectedLeague = listOfLeagueDetail.length > 0
                        ? listOfLeagueDetail.reduce((currentMax, element) {
                            int currentYear = currentMax.seasons![0].year;
                            int elementYear = element.seasons![0].year;
                            return elementYear > currentYear
                                ? element
                                : currentMax;
                          })
                        : null;

                    filteredGoalKeeperList = goalKeeperList.where((player) {
                      int playerSeason = player.season.contains("-")
                          ? int.parse(player.season.split("-")[0])
                          : int.tryParse(player.season) != null
                              ? int.parse(player.season)
                              : 0;
                      bool selectedPlayer =
                          (player.league == selectedLeague!.league.name) &&
                              selectedLeague!.seasons![0].year == playerSeason;
                      return selectedPlayer;
                    }).toList();

                    filteredOutfieldList = outfieldList.where((player) {
                      int playerSeason = player.season.contains("-")
                          ? int.parse(player.season.split("-")[0])
                          : int.tryParse(player.season) != null
                              ? int.parse(player.season)
                              : 0;
                      bool selectedPlayer =
                          (player.league == selectedLeague!.league.name) &&
                              selectedLeague!.seasons![0].year == playerSeason;
                      return selectedPlayer;
                    }).toList();
                  }
                });
              }
            },
          ),
          BlocListener<LeagueBloc, LeagueState>(
            listener: (context, state) {
              if (state is TeamSeasonLoaded) {
                setState(() {
                  Constant.leaguesSeasonList
                      .add({widget.team.id.toString(): state.success});
                  addLeagueSeason(state.success);

                  // LeagueDetails leagueDetail = leaguesSeason.reversed
                  //     .firstWhere(
                  //         (element) => element.league.id == widget.league.id);
                  // var season = leagueDetail.seasons!.reversed
                  //     .firstWhereOrNull((element) {
                  //   if (element.coverage != null &&
                  //       element.coverage!.fixtures != null &&
                  //       element.coverage!.fixtures!.statisticsPlayers != null) {
                  //     return element.coverage!.fixtures!.statisticsPlayers!;
                  //   } else {
                  //     return false;
                  //   }
                  // });
                  // if (season != null) {
                  //   _footballMatchBloc.add(GetPlayerStatsInfoRequest(
                  //       id: widget.team.id.toString(),
                  //       season: season.year.toString()));
                  // } else {
                  //   seasonIsNull = true;
                  // }
                });
              }
            },
          ),
        ],
        child: BlocBuilder<LeagueBloc, LeagueState>(
          builder: (context, state) {
            if (state is LoadTeamSeason) {
              return LoadingWidget();
            } else if (state is LeaguesError) {
              return ErrorWidget(state.message);
            } else {
              return BlocBuilder<FootballMatchBloc, FootballMatchState>(
                builder: (context, state) {
                  if (state is LoadPlayerStatsInfo) {
                    return LoadingWidget();
                  } else if (state is FootballMatchesError) {
                    return ErrorWidget(state.message);
                  } else {
                    if (playerStatList.length > 0 && selectedLeague != null) {
                      return ListView(
                        children: [
                          // LeagueDropdownButton(
                          //   selectedValue: selectedLeague!.name,
                          //   listOfLeague:
                          //       listOfLeague.map((e) => e.name).toList(),
                          //   matchList: playerStatList,
                          //   onChange: (value) {
                          //     setState(() {
                          //       selectedLeague = listOfLeague.firstWhere(
                          //           (element) =>
                          //               element.name == value as String);
                          //       // if (value == "All League") {
                          //       //   filteredMatches = matchList;
                          //       // } else {
                          //       //   filteredMatches = matchList
                          //       //       .where((e) => e.league!.name == value)
                          //       //       .toList();
                          //       // }
                          //     });
                          //   },
                          // ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    // hint:
                                    customButton: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        maxHeight: 50,
                                      ),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.list,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            height: 30,
                                            width: 30,
                                            color: Colors.white,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: FadeInImage.memoryNetwork(
                                                placeholder: kTransparentImage,
                                                image: selectedLeague!
                                                    .league.logo!,
                                                imageErrorBuilder: (e, o, c) {
                                                  return Container();
                                                }),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: AutoSizeText(
                                                selectedLeague!.league.name +
                                                    " " +
                                                    selectedLeague!
                                                        .seasons![0].year
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                minFontSize: 7,
                                                maxFontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            FontAwesomeIcons.caretDown,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      // customHeights: [48, 48, 48],
                                      height: 48,
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                    ),
                                    // customItemsHeight: 4,
                                    dropdownStyleData: DropdownStyleData(
                                      width: 300,
                                      maxHeight: 500,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                      elevation: 8,
                                      offset: const Offset(0, 8),
                                    ),
                                    items: listOfLeagueDetail
                                        .map(
                                          (item) => DropdownMenuItem<String>(
                                            value: item.league.name +
                                                " " +
                                                item.seasons![0].year
                                                    .toString(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 3),
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    child: FadeInImage
                                                        .memoryNetwork(
                                                            placeholder:
                                                                kTransparentImage,
                                                            image: item
                                                                .league.logo!,
                                                            imageErrorBuilder:
                                                                (e, o, c) {
                                                              return Container();
                                                            }),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: AutoSizeText(
                                                    item.league.name +
                                                        " " +
                                                        item.seasons![0].year
                                                            .toString(),
                                                    style: TextStyle(
                                                      color:
                                                          selectedLeague == item
                                                              ? Constant.color1
                                                              : Colors.black,
                                                    ),
                                                    minFontSize: 7,
                                                    maxFontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedLeague = listOfLeagueDetail
                                            .firstWhere((element) =>
                                                element.league.name +
                                                    " " +
                                                    element.seasons![0].year
                                                        .toString() ==
                                                value as String);
                                        filteredGoalKeeperList =
                                            goalKeeperList.where((player) {
                                          int playerSeason = player.season
                                                  .contains("-")
                                              ? int.parse(
                                                  player.season.split("-")[0])
                                              : int.tryParse(player.season) !=
                                                      null
                                                  ? int.parse(player.season)
                                                  : 0;
                                          bool selectedPlayer =
                                              (player.league ==
                                                      selectedLeague!
                                                          .league.name) &&
                                                  selectedLeague!
                                                          .seasons![0].year ==
                                                      playerSeason;
                                          return selectedPlayer;
                                        }).toList();

                                        filteredOutfieldList =
                                            outfieldList.where((player) {
                                          int playerSeason = player.season
                                                  .contains("-")
                                              ? int.parse(
                                                  player.season.split("-")[0])
                                              : int.tryParse(player.season) !=
                                                      null
                                                  ? int.parse(player.season)
                                                  : 0;
                                          bool selectedPlayer =
                                              (player.league ==
                                                      selectedLeague!
                                                          .league.name) &&
                                                  selectedLeague!
                                                          .seasons![0].year ==
                                                      playerSeason;
                                          return selectedPlayer;
                                        }).toList();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Goalkeepers",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 0.3)),
                              height:
                                  ((MediaQuery.of(context).size.height * 0.04) *
                                      (filteredGoalKeeperList.length + 1)),
                              child: PlayerStatsTable(
                                playerStats: filteredGoalKeeperList,
                                isGoalkeepers: true,
                                league: selectedLeague!,
                              )),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Players",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 0.3)),
                              height:
                                  ((MediaQuery.of(context).size.height * 0.04) *
                                      (filteredOutfieldList.length + 1)),
                              child: PlayerStatsTable(
                                playerStats: filteredOutfieldList,
                                isGoalkeepers: false,
                                league: selectedLeague!,
                              ))
                        ],
                      );
                    } else {
                      // if (playerStatList.length > 0 && ) {
                      //   return LoadingWidget();
                      // } else {
                      //   return
                      // }
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white)),
                          child: Center(
                            child: Text("No data"),
                          ));
                    }
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  addLeagueSeason(List<LeagueDetails> getLeagueSeason) {
    DateTime date = DateTime.now();
    getLeagueSeason.forEach((e) {
      League league = e.league;
      if (e.seasons != null && e.seasons!.length > 0) {
        // Season? lastestSeason = e.seasons!.reversed.firstWhereOrNull((season) =>
        //     season.coverage!.fixtures != null &&
        //     season.coverage!.fixtures!.statisticsPlayers != null &&
        //     season.coverage!.fixtures!.statisticsPlayers!);
        // if (lastestSeason != null)
        //   listOfLeagueDetail.add(LeagueDetails(
        //       league: league, country: e.country, seasons: [lastestSeason]));

        e.seasons!.forEach((season) {
          if (season.coverage!.fixtures != null &&
              season.coverage!.fixtures!.statisticsPlayers != null &&
              season.coverage!.fixtures!.statisticsPlayers! &&
              season.year >= (date.year - 3)) {
            listOfLeagueDetail.add(LeagueDetails(
                league: league, country: e.country, seasons: [season]));
          }
        });
      }
    });

    if (listOfLeagueDetail.length > 0) {
      // List<int> listOfYear =
      //     listOfLeagueDetail.map((e) => e.seasons![0].year).toList();
      // int minYear = listOfYear.min;
      // int maxYear = listOfYear.max;

      _footballMatchBloc.add(GetPlayerStatsInfoRequest(
          id: widget.team.id.toString(), season: "2020"));
    }
  }
}
