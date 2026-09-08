import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:soccer_sport/favourite/presentation/widget/favourite_team_dialog_header.dart';
import 'package:soccer_sport/favourite/presentation/widget/favourite_team_dialog_listtile.dart';
import 'package:soccer_sport/favourite/presentation/widget/favourite_team_group_header.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/presentation/widget/league_country_name_seperator.dart';
import 'package:azlistview/azlistview.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:group_list_view/group_list_view.dart';

import '../../../footballMatch/domain/entities/team.dart';
import '../../../injection_container.dart';

class FavouriteTeamDialog extends StatefulWidget {
  final FavouriteBloc favouriteBloc;
  FavouriteTeamDialog({required this.favouriteBloc});
  @override
  State<FavouriteTeamDialog> createState() => _FavouriteTeamDialogState();
}

class _FavouriteTeamDialogState extends State<FavouriteTeamDialog> {
  Map<String, List<Team>> searchedResult = {};
  late Map<String, List<Team>> teamList;
  late List<Team> favouriteTeam = [];

  late FavouriteBloc _favouriteBloc;
  String searchValue = '';
  final TextEditingController _controller = TextEditingController();
  Map<String, String> leagueMap = {
    '1': 'FIFA World Cup(tm)',
    '39': 'Premier League',
    '61': 'Ligue 1',
    '78': 'Bundesliga',
    '140': 'La Liga',
  };
  @override
  void initState() {
    // searchedResult = List<LeagueDetails>.from(Constant.staticLeagues);
    teamList = Constant.teamList;
    _favouriteBloc = widget.favouriteBloc;
    _favouriteBloc.add(GetFavouriteTeamRequestV2());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // scrollable: true,
      // actions: [
      //   IconButton(
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ],
      child: BlocListener<FavouriteBloc, FavouriteState>(
        bloc: _favouriteBloc,
        listener: (context, state) {
          if (state is FavouriteTeamV2Loaded) {
            setState(() {
              favouriteTeam = state.teams;
            });
          }
          if (state is FavouriteTeamV2Persisted) {
            if (state.teams) {
              _favouriteBloc.add(GetFavouriteTeamRequestV2());
            }
          }

          if (state is FavouriteTeamV2Removed) {
            _favouriteBloc.add(GetFavouriteTeamRequestV2());
          }
        },
        child: Container(
          decoration: BoxDecoration(color: Constant.backgroundColor),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlineSearchBar(
                textEditingController: _controller,
                onClearButtonPressed: (v) {
                  setState(() {
                    searchedResult.clear();
                    searchValue = '';
                  });
                },
                onSearchButtonPressed: (value) {
                  searchedResult = {};
                  setState(() {
                    teamList.forEach((key, values) {
                      List<Team> searchedTeam = [];
                      values.forEach((e) {
                        if (e.name.toLowerCase().split(' ').any((element) =>
                            element.contains(value.toLowerCase()))) {
                          searchedTeam.add(e);
                        }
                      });
                      if (searchedTeam.isNotEmpty) {
                        searchedResult[key] = searchedTeam;
                      }
                    });

                    searchValue = value;
                  });
                },
              ),
            ),
            searchedResult.isNotEmpty || searchValue != ''
                ? Expanded(
                    child: GroupListView(
                      addAutomaticKeepAlives: false,
                      shrinkWrap: true,
                      sectionsCount: searchedResult.keys.toList().length,
                      countOfItemInSection: (int section) {
                        return searchedResult.values.toList()[section].length;
                      },
                      itemBuilder: (BuildContext context, IndexPath index) {
                        Team team = searchedResult.values
                            .toList()[index.section][index.index];
                        String id = searchedResult.keys.toList()[index.section];
                        bool isFavourited = favouriteTeam.isNotEmpty &&
                                favouriteTeam.length > 0 &&
                                favouriteTeam.firstWhereOrNull(
                                        (element) => element.id == team.id) !=
                                    null
                            ? true
                            : false;

                        return FavouriteTeamDialogListtile(
                          team: searchedResult.values.toList()[index.section]
                              [index.index],
                          isFavourite: isFavourited,
                          favouriteFunction: () {
                            if (isFavourited) {
                              _favouriteBloc.add(
                                  RemoveFavouriteTeamRequestV2(teams: team));
                            } else {
                              _favouriteBloc.add(
                                  PersistFavouriteTeamRequestV2(teams: team));
                            }
                          },
                        );
                      },
                      groupHeaderBuilder: (BuildContext context, int section) {
                        return FavouriteTeamDialogHeader(
                            name: leagueMap[
                                searchedResult.keys.toList()[section]]!);
                      },

                      // groupSeparatorBuilder: (String league) =>
                      //     FootballMatchLeagueSeperator(
                      //       league: league,
                      //       matchs: liveMatches,
                      //     ),
                      // indexedItemBuilder:
                      //     (context, FootballMatch match, int index) {
                      //   return FootballMatchLiveListTile(
                      //     footballMatch: match,
                      //   );
                      // }
                    ),
                  )
                : Expanded(
                    child: GroupListView(
                      addAutomaticKeepAlives: false,
                      shrinkWrap: true,
                      sectionsCount: teamList.keys.toList().length,
                      countOfItemInSection: (int section) {
                        return teamList.values.toList()[section].length;
                      },

                      itemBuilder: (BuildContext context, IndexPath index) {
                        Team team = teamList.values.toList()[index.section]
                            [index.index];
                        String id = teamList.keys.toList()[index.section];
                        bool isFavourited = favouriteTeam.isNotEmpty &&
                                favouriteTeam.length > 0 &&
                                favouriteTeam.firstWhereOrNull(
                                        (element) => element.id == team.id) !=
                                    null
                            ? true
                            : false;
                        return FavouriteTeamDialogListtile(
                          team: teamList.values.toList()[index.section]
                              [index.index],
                          isFavourite: isFavourited,
                          favouriteFunction: () {
                            if (isFavourited) {
                              _favouriteBloc.add(
                                  RemoveFavouriteTeamRequestV2(teams: team));
                            } else {
                              _favouriteBloc.add(
                                  PersistFavouriteTeamRequestV2(teams: team));
                            }
                          },
                        );
                      },
                      groupHeaderBuilder: (BuildContext context, int section) {
                        return FavouriteTeamDialogHeader(
                            name: leagueMap[teamList.keys.toList()[section]]!);
                      },

                      // groupSeparatorBuilder: (String league) =>
                      //     FootballMatchLeagueSeperator(
                      //       league: league,
                      //       matchs: liveMatches,
                      //     ),
                      // indexedItemBuilder:
                      //     (context, FootballMatch match, int index) {
                      //   return FootballMatchLiveListTile(
                      //     footballMatch: match,
                      //   );
                      // }
                    ),
                  )
          ]),
        ),
      ),
    );
  }
}
