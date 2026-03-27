import 'package:soccer_sport/footballMatch/data/model/goal_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/goal.dart';
import 'package:soccer_sport/footballMatch/domain/entities/score.dart';

class ScoreModel extends Score {
  ScoreModel({
    GoalModel? halftime,
    GoalModel? fulltime,
    GoalModel? extratime,
    GoalModel? penalty,
  }) : super(
          halftime: halftime,
          fulltime: fulltime,
          extratime: extratime,
          penalty: penalty,
        );

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      halftime: json['halftime'] != null
          ? GoalModel.fromJson(json['halftime'])
          : null,
      fulltime: json['fulltime'] != null
          ? GoalModel.fromJson(json['fulltime'])
          : null,
      extratime: json['fulltime'] != null
          ? GoalModel.fromJson(json['fulltime'])
          : null,
      penalty: json['fulltime'] != null
          ? GoalModel.fromJson(json['fulltime'])
          : null,
    );
  }

  ScoreModel.fromEntity(Score scoreModel)
      : super(
          halftime: scoreModel.halftime,
          fulltime: scoreModel.fulltime,
          extratime: scoreModel.extratime,
          penalty: scoreModel.penalty,
        );

  Map<String, dynamic> toJson() {
    return {
      'halftime':
          halftime != null ? GoalModel.fromEntity(halftime!).toJson() : null,
      'fulltime':
          fulltime != null ? GoalModel.fromEntity(fulltime!).toJson() : null,
      'extratime':
          extratime != null ? GoalModel.fromEntity(extratime!).toJson() : null,
      'penalty':
          penalty != null ? GoalModel.fromEntity(penalty!).toJson() : null,
    };
  }
}
