import 'package:soccer_sport/standings/data/model/goals_model.dart';
import 'package:soccer_sport/standings/data/model/standing_model.dart';
import 'package:soccer_sport/standings/domain/entities/goals.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/entities/score.dart';

class ScoreModel extends Score {
  ScoreModel({
    int? played,
    int? win,
    int? draw,
    int? lose,
    GoalsModel? goals,
  }) : super(
          played: played,
          win: win,
          draw: draw,
          lose: lose,
          goals: goals,
        );

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      played: json['played'],
      win: json['win'],
      draw: json['draw'],
      lose: json['lose'],
      goals: json['goals'] != null ? GoalsModel.fromJson(json['goals']) : null,
    );
  }

  ScoreModel.fromEntity(Score score)
      : super(
          played: score.played,
          win: score.win,
          draw: score.draw,
          lose: score.lose,
          goals: score.goals,
        );
  Map<String, dynamic> toJson() {
    return {
      'played': played,
      'win': win,
      'draw': draw,
      'lose': lose,
      'goals': goals,
    };
  }
}
