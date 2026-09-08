import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team_info/player_cards.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team_info/player_goal.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';

import 'package:soccer_sport/league/domain/entities/league.dart';

import '../goal.dart';

class PlayerStats extends Equatable {
  PlayerCard playerCard;
  PlayerGoal playerGoal;
  League league;
  PlayerStats({
    required this.playerCard,
    required this.playerGoal,
    required this.league,
  });

  @override
  List<Object?> get props => [playerCard, playerGoal];

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
        playerCard: PlayerCard.fromJson(json["cards"]),
        league: LeagueModel.fromJson(json["league"]),
        playerGoal: PlayerGoal.fromJson(json["goals"]));
  }
}
