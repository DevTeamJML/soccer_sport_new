import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/data/model/team_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team.dart';
import 'package:soccer_sport/standings/data/model/score_model.dart';
import 'package:soccer_sport/standings/domain/entities/score.dart';
import 'package:soccer_sport/standings/domain/entities/standing.dart';

class StandingModel extends Standing {
  StandingModel({
    required int rank,
    required Team team,
    required int points,
    required int goalsDiff,
    required String group,
    String? form,
    String? status,
    String? description,
    String? update,
    required Score all,
    required Score home,
    required Score away,
  }) : super(
          rank: rank,
          team: team,
          points: points,
          goalsDiff: goalsDiff,
          group: group,
          form: form,
          status: status,
          description: description,
          update: update,
          all: all,
          home: home,
          away: away,
        );

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags}),

  factory StandingModel.fromJson(Map<String, dynamic> json) {
    return StandingModel(
      rank: json['rank'],
      team: TeamModel.fromJson(json['team']),
      points: json['points'],
      goalsDiff: json['goalsDiff'],
      group: json['group'],
      form: json['form'],
      status: json['status'],
      description: json['description'],
      update: json['update'],
      all: ScoreModel.fromJson(json['all']),
      home: ScoreModel.fromJson(json['home']),
      away: ScoreModel.fromJson(json['away']),
    );
  }

  StandingModel.fromEntity(Standing standing)
      : super(
          rank: standing.rank,
          team: standing.team,
          points: standing.points,
          goalsDiff: standing.goalsDiff,
          group: standing.group,
          form: standing.form,
          status: standing.status,
          description: standing.description,
          update: standing.update,
          all: standing.all,
          home: standing.home,
          away: standing.away,
        );
  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'team': team,
      'points': points,
      'goalsDiff': goalsDiff,
      'group': group,
      'form': form,
      'status': status,
      'description': description,
      'update': update,
      'all': all,
      'home': home,
      'away': away,
    };
  }
}
