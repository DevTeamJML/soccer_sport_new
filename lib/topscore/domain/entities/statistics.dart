import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:soccer_sport/topscore/domain/entities/statistics_sub/cards.dart';
import 'package:soccer_sport/topscore/domain/entities/statistics_sub/dribbles.dart';
import 'package:soccer_sport/topscore/domain/entities/statistics_sub/duels.dart';
import 'package:soccer_sport/topscore/domain/entities/statistics_sub/fouls.dart';
import 'package:soccer_sport/topscore/domain/entities/statistics_sub/games.dart';
import 'package:soccer_sport/topscore/domain/entities/statistics_sub/goals.dart';
import 'package:soccer_sport/topscore/domain/entities/statistics_sub/passes.dart';
import 'package:soccer_sport/topscore/domain/entities/statistics_sub/penalty.dart';
import 'package:soccer_sport/topscore/domain/entities/statistics_sub/shots.dart';
import 'package:soccer_sport/topscore/domain/entities/statistics_sub/substitutes.dart';
import 'package:soccer_sport/topscore/domain/entities/statistics_sub/tackles.dart';
import 'package:soccer_sport/topscore/domain/entities/statistics_sub/team.dart';

class Statistic extends Equatable {
  final Cards? cards;
  final Dribbles? dribbles;
  final Duels? duels;
  final Fouls? fouls;
  final Games? games;
  final Goals? goals;
  final Passes? passes;
  final Penalty? penalty;
  final Shots? shots;
  final Substitutes? substitutes;
  final Tackels? tackels;
  final Team? team;
  Statistic({
    this.cards,
    this.dribbles,
    this.duels,
    this.fouls,
    this.games,
    this.goals,
    this.passes,
    this.penalty,
    this.shots,
    this.substitutes,
    this.tackels,
    this.team,
  });
  @override
  List<Object?> get props => [
        cards,
        dribbles,
        duels,
        fouls,
        games,
        goals,
        passes,
        penalty,
        shots,
        substitutes,
        tackels,
        team,
      ];

  Map<String, dynamic> toMap() {
    return {
      'cards': cards?.toMap(),
      'dribbles': dribbles?.toMap(),
      'duels': duels?.toMap(),
      'fouls': fouls?.toMap(),
      'games': games?.toMap(),
      'goals': goals?.toMap(),
      'passes': passes?.toMap(),
      'penalty': penalty?.toMap(),
      'shots': shots?.toMap(),
      'substitutes': substitutes?.toMap(),
      'tackels': tackels?.toMap(),
      'team': team?.toMap(),
    };
  }

  factory Statistic.fromMap(Map<String, dynamic> map) {
    return Statistic(
      cards: map['cards'] != null ? Cards.fromMap(map['cards']) : null,
      dribbles:
          map['dribbles'] != null ? Dribbles.fromMap(map['dribbles']) : null,
      duels: map['duels'] != null ? Duels.fromMap(map['duels']) : null,
      fouls: map['fouls'] != null ? Fouls.fromMap(map['fouls']) : null,
      games: map['games'] != null ? Games.fromMap(map['games']) : null,
      goals: map['goals'] != null ? Goals.fromMap(map['goals']) : null,
      passes: map['passes'] != null ? Passes.fromMap(map['passes']) : null,
      penalty: map['penalty'] != null ? Penalty.fromMap(map['penalty']) : null,
      shots: map['shots'] != null ? Shots.fromMap(map['shots']) : null,
      substitutes: map['substitutes'] != null
          ? Substitutes.fromMap(map['substitutes'])
          : null,
      tackels: map['tackels'] != null ? Tackels.fromMap(map['tackels']) : null,
      team: map['team'] != null ? Team.fromMap(map['team']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Statistic.fromJson(String source) =>
      Statistic.fromMap(json.decode(source));
}
