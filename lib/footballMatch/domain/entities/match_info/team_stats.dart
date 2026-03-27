import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/last5.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/league_stat.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class TeamStat extends Equatable {
  Last5 last5;
  LeagueStat leagueStat;

  TeamStat({required this.last5, required this.leagueStat});

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [last5, leagueStat];

  Map<String, dynamic> toMap() {
    return {
      'last_5': last5.toMap(),
      'league': leagueStat.toMap(),
    };
  }

  factory TeamStat.fromMap(Map<String, dynamic> map) {
    var value = 0;

    return TeamStat(
      last5: Last5.fromMap(map['last_5']),
      leagueStat: LeagueStat.fromMap(map['league']),
    );
  }
}
