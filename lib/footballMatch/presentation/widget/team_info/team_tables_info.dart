import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/team_info/league_dropdown_button.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../core/constant/constants.dart';
import '../../../../injection_container.dart';
import '../../../../league/domain/entities/league.dart';
import '../../../../league/domain/entities/league_details.dart';
import '../../../../league/domain/entities/season.dart';
import '../../../../league/presentation/bloc/league_bloc.dart';
import '../../../../league/presentation/widget/league_tables_tab.dart';
import '../../../../standings/domain/entities/league_standings.dart';
import '../../../../standings/presentation/bloc/standing_bloc.dart';
import '../../../domain/entities/football_match.dart';
import '../../../domain/entities/team.dart';

class TeamTablesInfo extends StatefulWidget {
  final Team team;
  final League league;

  const TeamTablesInfo({
    required this.team,
    required this.league,
  });

  @override
  State<TeamTablesInfo> createState() => _TeamTablesInfoState();
}

class _TeamTablesInfoState extends State<TeamTablesInfo> {
  final StandingBloc _standingBloc = serviceLocator<StandingBloc>();
  final LeagueBloc _leagueBloc = serviceLocator<LeagueBloc>();

  List<LeagueStandings> standingList = [];
  LeagueStandings? filteredStanding;
  List<String> listOfLeagueName = [];
  List<LeagueDetails> listOfLeagueDetail = [];
  String? selection;

  String selectedValue = "";
  LeagueDetails? selectedLeague;
  //  List<String> listOfLeague;
  bool seasonIsNull = false;

  @override
  void initState() {
    super.initState();

    var constantSeason = Constant.leaguesSeasonList.firstWhereOrNull(
        (element) => element[widget.team.id.toString()] != null);

    if (constantSeason != null && constantSeason.isNotEmpty) {
      var fetchedLeagueDetails = constantSeason[widget.team.id.toString()]!;
      addLeagueSeason(fetchedLeagueDetails);

      // LeagueDetails leagueDetail = leaguesSeason.reversed
      //     .firstWhere((element) => element.league.id == widget.league.id);
      // var season = leagueDetail.seasons!.reversed.firstWhereOrNull((element) {
      //   if (element.coverage != null && element.coverage!.standings != null) {
      //     return element.coverage!.standings!;
      //   } else {
      //     return false;
      //   }
      // });
      // if (season != null) {
      //   addLeagueSeason(leaguesSeason);

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
          create: (context) => _standingBloc,
        ),
        BlocProvider(
          create: (context) => _leagueBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<StandingBloc, StandingState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is StandingsLoaded) {
                setState(() {
                  if (state.standings != null) {
                    standingList.add(state.standings!);
                    filteredStanding = standingList.firstWhere((element) =>
                        element.name! + " " + element.season!.toString() ==
                        selectedLeague!.league.name +
                            " " +
                            selectedLeague!.seasons![0].year.toString());
                  } else {
                    filteredStanding = null;
                  }

                  // else {
                  //   listOfLeagueName.remove(selectedValue);
                  //   listOfLeague
                  //       .removeWhere((element) => element.name == selectedValue);
                  //   selectedValue = listOfLeagueName[0];
                  //   var leagueID = listOfLeague
                  //       .firstWhere((element) => element.name == selectedValue);
                  //   _standingBloc.add(GetStandingsByLeagueRequest(
                  //       id: leagueID.id.toString(),
                  //       season: widget.league.seasons!));
                  // }
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
                });
              }
            },
          ),
        ],
        child: BlocBuilder<StandingBloc, StandingState>(
          builder: (context, state) {
            if (state is LoadStandings) {
              return LoadingWidget();
            } else if (state is StandingsError) {
              return ErrorWidget(state.message);
            } else {
              return Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                child: ListView(
                  children: [
                    // LeagueDropdownButton(
                    //   selectedValue: selectedValue,
                    //   listOfLeague: listOfLeagueName,
                    //   matchList: standingList,
                    //   onChange: (value) {
                    //     setState(() {
                    //       selectedValue = value as String;
                    //       var standingExist = standingList.firstWhereOrNull(
                    //           (element) => element.name == selectedValue);
                    //       if (standingExist != null) {
                    //         filteredStanding = standingExist;
                    //       } else {
                    //         var league = listOfLeague.firstWhere(
                    //             (element) => element.name == selectedValue);

                    //         _standingBloc.add(GetStandingsByLeagueRequest(
                    //             id: league.id.toString(),
                    //             season: widget.league.seasons!));
                    //       }
                    //     });
                    //   },
                    // ),

                    if (selectedLeague != null)
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
                                      maxHeight: 50),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
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
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image: listOfLeagueDetail
                                                        .firstWhereOrNull((e) =>
                                                            e ==
                                                            selectedLeague) !=
                                                    null
                                                ? listOfLeagueDetail
                                                    .firstWhereOrNull((e) =>
                                                        e == selectedLeague)!
                                                    .league
                                                    .logo!
                                                : '',
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
                                                selectedLeague!.seasons![0].year
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
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
                                            item.seasons![0].year.toString(),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    FadeInImage.memoryNetwork(
                                                        placeholder:
                                                            kTransparentImage,
                                                        image:
                                                            item.league.logo!,
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
                                                  color: selectedLeague == item
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
                                            (element.league.name +
                                                " " +
                                                element.seasons![0].year
                                                    .toString()) ==
                                            value as String);
                                    var standingExist = standingList
                                        .firstWhereOrNull((element) =>
                                            (element.name! +
                                                " " +
                                                element.season!.toString()) ==
                                            value);
                                    if (standingExist != null) {
                                      filteredStanding = standingExist;
                                    } else {
                                      filteredStanding = null;
                                      // selectedLeague = listOfLeagueDetail.firstWhere(
                                      //     (element) =>
                                      //         element.name +
                                      //             " " +
                                      //             element.seasons!.toString() ==
                                      //         value as String);

                                      _standingBloc.add(
                                          GetStandingsByLeagueRequest(
                                              id:
                                                  selectedLeague!
                                                      .league.id
                                                      .toString(),
                                              season: selectedLeague!
                                                  .seasons![0].year));
                                    }
                                  });

                                  //       selectedValue = value as String;
                                  //       var standingExist = standingList.firstWhereOrNull(
                                  //           (element) => element.name == selectedValue);
                                  //       if (standingExist != null) {
                                  //         filteredStanding = standingExist;
                                  //       } else {
                                  //         var league = listOfLeague.firstWhere(
                                  //             (element) => element.name == selectedValue);

                                  //         _standingBloc.add(GetStandingsByLeagueRequest(
                                  //             id: league.id.toString(),
                                  //             season: widget.league.seasons!));
                                  //       }
                                  //     });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    standingTab(),
                    filteredStanding != null
                        ? Container(
                            height:
                                ((MediaQuery.of(context).size.height * 0.05) *
                                    (filteredStanding!.standings.length + 1)),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                                border: Border.all(
                                    color: Colors.white, width: 0.5)),
                            child: LeagueTablesTab(
                              standings: filteredStanding!,
                              selection: selection,
                              team: widget.team,
                              // ),
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white)),
                            child: Center(
                              child: Text("No data"),
                            )),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget standingTab() {
    return Container(
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
                      border: Border.all(color: Colors.white, width: 0.5),
                      color:
                          selection == null ? Colors.white : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Center(
                        child: Text(
                      "All",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selection == null ? Colors.black : Colors.white,
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
                      border: Border.all(color: Colors.white, width: 0.5),
                      color: selection == "home"
                          ? Colors.white
                          : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Center(
                        child: Text(
                      "Home",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            selection == "home" ? Colors.black : Colors.white,
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
                      border: Border.all(color: Colors.white, width: 0.5),
                      color: selection == "away"
                          ? Colors.white
                          : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Center(
                        child: Text(
                      "Away",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            selection == "away" ? Colors.black : Colors.white,
                      ),
                    )))),
          ],
        ));
  }

  addLeagueSeason(List<LeagueDetails> getLeagueSeason) {
    DateTime date = DateTime.now();
    getLeagueSeason.forEach((e) {
      League league = e.league;
      if (e.seasons != null && e.seasons!.length > 0) {
        e.seasons!.forEach((season) {
          if (season.coverage!.standings! && season.year >= (date.year - 3)) {
            listOfLeagueDetail.add(LeagueDetails(
                league: league, country: e.country, seasons: [season]));
          }
        });
      }
    });
    if (listOfLeagueDetail.length > 0) {
      selectedLeague = listOfLeagueDetail[0];
      _standingBloc.add(GetStandingsByLeagueRequest(
          id: selectedLeague!.league.id.toString(),
          season: selectedLeague!.seasons![0].year));
    }
  }
}
