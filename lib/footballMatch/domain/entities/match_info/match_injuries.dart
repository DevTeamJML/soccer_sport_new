import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/coach.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/player_injuries.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/player_pos.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/stats_info.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class MatchInjuries extends Equatable {
  Team team;
  PlayerInjuries player;

  MatchInjuries({
    required this.team,
    required this.player,
  });

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [team, player];

  Map<String, dynamic> toMap() {
    return {
      'team': team.toMap(),
      'player': player.toMap(),
    };
  }

  factory MatchInjuries.fromMap(Map<String, dynamic> map) {
    return MatchInjuries(
      team: Team.fromMap(map['team']),
      player: PlayerInjuries.fromMap(map['player']),
    );
  }
}
