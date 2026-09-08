import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:soccer_sport/topscore/domain/entities/players.dart';
import 'package:soccer_sport/topscore/domain/entities/statistics.dart';

class TopScore extends Equatable {
  final Player player;
  final Statistic statistic;

  TopScore({required this.player, required this.statistic});
  @override
  List<Object> get props => [
        player,
        statistic,
      ];

  Map<String, dynamic> toMap() {
    return {
      'player': player.toMap(),
      'statistic': statistic.toMap(),
    };
  }

  factory TopScore.fromMap(Map<String, dynamic> map) {
    return TopScore(
      player: Player.fromMap(map['player']),
      statistic: Statistic.fromMap(map['statistics'][0]),
    );
  }
}
