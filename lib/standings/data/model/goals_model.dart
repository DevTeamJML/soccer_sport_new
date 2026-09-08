import 'package:soccer_sport/standings/data/model/standing_model.dart';
import 'package:soccer_sport/standings/domain/entities/goals.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';

class GoalsModel extends Goals {
  GoalsModel({
    int? goalsFor,
    int? against,
  }) : super(
          goalsFor: goalsFor,
          against: against,
        );

  factory GoalsModel.fromJson(Map<String, dynamic> json) {
    return GoalsModel(
      goalsFor: json['for'] != null ? json['for'] : 0,
      against: json['against'] != null ? json['against'] : 0,
    );
  }

  GoalsModel.fromEntity(Goals goals)
      : super(
          goalsFor: goals.goalsFor,
          against: goals.against,
        );
  Map<String, dynamic> toJson() {
    return {
      'goalsFor': goalsFor,
      'against': against,
    };
  }
}
