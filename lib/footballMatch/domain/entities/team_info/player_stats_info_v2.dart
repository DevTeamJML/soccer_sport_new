import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team_info/player_cards.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team_info/player_goal.dart';

import 'package:soccer_sport/footballMatch/domain/entities/team_info/player_stats.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';

import '../goal.dart';

class PlayerStatsInfoV2 extends Equatable {
  int id;
  String name;
  String position;
  String league;
  String season;
  PlayerGoal playerGoal;
  PlayerCard playerCard;

  PlayerStatsInfoV2({
    required this.id,
    required this.name,
    // required this.image,
    required this.league,
    required this.season,
    required this.position,
    required this.playerGoal,
    required this.playerCard,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        // image,
        position,
        league,
        season,
        playerCard,
        playerGoal,
      ];
  factory PlayerStatsInfoV2.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> goal = json['goals'];
    Map<String, dynamic> card = json['cards'];

    return PlayerStatsInfoV2(
      id: json["player_id"],
      name: json["player_name"],
      position: json["position"],
      league: json['league'] != null ? json['league'] : "",
      season: json['season'] != null ? json['season'] : "",
      playerGoal: PlayerGoal.fromJson(goal),
      playerCard: PlayerCard.fromJson(card),
      // image: json["photo"] != null ? player["photo"] : null,
      // playerStats: stats.map((e) => PlayerStats.fromJson(e)).toList(),
    );
  }
}
