import 'package:equatable/equatable.dart';

import 'package:soccer_sport/footballMatch/domain/entities/team_info/player_stats.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';

import '../goal.dart';

class PlayerStatsInfo extends Equatable {
  int id;
  String name;
  String? image;
  String position;

  List<PlayerStats> playerStats;

  PlayerStatsInfo({
    required this.id,
    required this.name,
    required this.image,
    required this.position,
    required this.playerStats,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        position,
        playerStats,
      ];
  factory PlayerStatsInfo.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> player = json["player"];
    List<dynamic> stats = json["statistics"];
    Map<String, dynamic> games = json["statistics"][0]["games"];

    return PlayerStatsInfo(
      id: player["id"],
      name: player["name"],
      position: games["position"],
      image: player["photo"] != null ? player["photo"] : null,
      playerStats: stats.map((e) => PlayerStats.fromJson(e)).toList(),
    );
  }
}
