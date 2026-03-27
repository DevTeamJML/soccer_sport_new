import 'package:soccer_sport/footballMatch/domain/entities/goal.dart';

class GoalModel extends Goal {
  GoalModel({
    int? home,
    int? away,
  }) : super(
          home: home,
          away: away,
        );

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
        home: json['home'] != null ? json['home'] : 0,
        away: json['away'] != null ? json['away'] : 0);
  }

  GoalModel.fromEntity(Goal goalModel)
      : super(
          home: goalModel.home,
          away: goalModel.away,
        );

  Map<String, dynamic> toJson() {
    return {
      'home': home,
      'away': away,
    };
  }
}
