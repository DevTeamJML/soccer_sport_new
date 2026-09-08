import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constant/constants.dart';
import '../../../../league/domain/entities/league.dart';
import '../../../../league/domain/entities/league_details.dart';
import '../../../domain/entities/team_info/player_stats.dart';
import '../../../domain/entities/team_info/player_stats_info.dart';
import '../../../domain/entities/team_info/player_stats_info_v2.dart';

class PlayerStatsTable extends StatelessWidget {
  final bool isGoalkeepers;
  final LeagueDetails league;
  final List<PlayerStatsInfoV2> playerStats;

  const PlayerStatsTable(
      {required this.playerStats,
      required this.isGoalkeepers,
      required this.league});

  @override
  Widget build(BuildContext context) {
    List<PlayerStatsInfoV2> playerByLeague = playerStats;

    // = playerStats.where((player) {
    //   int playerSeason = player.season.contains("-")
    //       ? int.parse(player.season.split("-")[0])
    //       : int.tryParse(player.season) != null
    //           ? int.parse(player.season)
    //           : 0;
    //   bool selectedPlayer = (player.league == league.league.name) &&
    //       league.seasons![0].year == playerSeason;
    //   return selectedPlayer;
    // }).toList();
    playerByLeague.sort((a, b) => isGoalkeepers
        ? b.playerGoal.saves.compareTo(a.playerGoal.saves)
        : b.playerGoal.total.compareTo(a.playerGoal.total));

    return Column(
      children: List.generate(playerByLeague.length + 1, (
        index,
      ) {
        if (index == 0) {
          return Expanded(
            child: Container(
              color: Constant.color2,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Center(
                        child: Text(
                      'Name',
                      style: TextStyle(color: Colors.black),
                    )),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Center(
                          child: Text(
                            isGoalkeepers ? 'GS' : "G",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          isGoalkeepers ? 'GC' : "A",
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'YC',
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'RC',
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                ],
              ),
            ),
          );
        } else {
          PlayerStatsInfoV2 playerStat = playerByLeague[index - 1];
          // PlayerStats player = playerStat.playerStats.firstWhere((element) =>
          //     // element.league.name + " " + element.league.seasons!.toString() ==
          //     // (league.league.name + " " + league.seasons![0].year.toString())
          //     element.league.name == (league.league.name));

          Color textColors = Colors.white;
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.white, width: 0.3))),
              padding: EdgeInsets.only(left: 5),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          // Expanded(
                          //   flex: 1,
                          //   child: playerStat.image != null
                          //       ? Image.network(
                          //           playerStat.image!,
                          //           height: MediaQuery.of(context).size.height *
                          //               0.05,
                          //         )
                          //       : Container(
                          //           margin: EdgeInsets.all(10),
                          //           decoration: BoxDecoration(
                          //             color: Colors.grey,
                          //             // borderRadius: BorderRadius.circular(50),
                          //           ),
                          //           // child: Center(
                          //           //     child: Icon(
                          //           //   FontAwesomeIcons.exclamation,
                          //           //   color: Colors.white,
                          //           //   size: 12,
                          //           // )),
                          //         ),
                          // ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              flex: 5,
                              child: Text(
                                playerStat.name,
                                style: TextStyle(
                                  color: textColors,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                              )),
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          isGoalkeepers
                              ? playerStat.playerGoal.saves.toString()
                              : playerStat.playerGoal.total.toString(),
                          style: TextStyle(
                              color: textColors,
                              fontSize: 11,
                              fontWeight: FontWeight.normal),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          isGoalkeepers
                              ? playerStat.playerGoal.conceded.toString()
                              : playerStat.playerGoal.assists.toString(),
                          style: TextStyle(
                            color: textColors,
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          playerStat.playerCard.yellow.toString(),
                          style: TextStyle(
                            color: textColors,
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          playerStat.playerCard.red.toString(),
                          style: TextStyle(
                            color: textColors,
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}
