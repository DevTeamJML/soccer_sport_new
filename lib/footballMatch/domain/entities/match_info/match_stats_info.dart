import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/stats_info.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class MatchStatsInfo extends Equatable {
  Team team;
  List<StatsInfo> statsInfo;
  MatchStatsInfo({required this.team, required this.statsInfo});

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [team, statsInfo];

  Map<String, dynamic> toMap() {
    return {
      'team': team.toMap(),
      'set_paid': statsInfo.map((e) => e.toMap()).toList(),
    };
  }

  factory MatchStatsInfo.fromMap(Map<String, dynamic> map) {
    return MatchStatsInfo(
      team: Team.fromMap(map['team']),
      statsInfo: (map['statistics'] as List<dynamic>)
          .map((e) => StatsInfo.fromMap(e))
          .toList(),
    );
  }
}
