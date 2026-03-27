import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/coach.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/player_pos.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/stats_info.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class MatchLineups extends Equatable {
  Team team;
  Coach coach;
  String? formation;
  List<PlayerPos> startXI;
  List<PlayerPos> substitutes;

  MatchLineups(
      {required this.team,
      this.formation,
      required this.coach,
      required this.startXI,
      required this.substitutes});

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [team, formation, coach, startXI, substitutes];

  Map<String, dynamic> toMap() {
    return {
      'team': team.toMap(),
      'coach': coach.toMap(),
      'formation': formation,
      'startXI': startXI.map((e) => e.toMap()).toList(),
      'substitutes': substitutes.map((e) => e.toMap()).toList(),
    };
  }

  factory MatchLineups.fromMap(Map<String, dynamic> map) {
    return MatchLineups(
      team: Team.fromMap(map['team']),
      coach: Coach.fromMap(map['coach']),
      formation: map['formation'],
      startXI: (map['startXI'] as List<dynamic>)
          .map((e) => PlayerPos.fromMap(e['player']))
          .toList(),
      substitutes: (map['substitutes'] as List<dynamic>)
          .map((e) => PlayerPos.fromMap(e['player']))
          .toList(),
    );
  }
}
