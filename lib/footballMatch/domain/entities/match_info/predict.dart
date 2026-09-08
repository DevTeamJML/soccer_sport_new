import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/coach.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/compare.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/player_pos.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/predictions.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/stats_info.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/team_stats.dart';

class Predict extends Equatable {
  // Compare form;
  // Compare att;
  // Compare def;
  // Compare poisson;
  // Compare h2hCompare;
  // Compare goals;
  // Compare total;
  Predictions predictions;
  TeamStat home;
  TeamStat away;

  List<FootballMatch> h2h;

  Predict({
    required this.h2h,
    required this.predictions,
    required this.home,
    required this.away,

    // required this.form,
    // required this.att,
    // required this.def,
    // required this.poisson,
    // required this.h2hCompare,
    // required this.goals,
    // required this.total,
  });

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [
        h2h,
        predictions,
        home,
        away,

        // form,
        // att,
        // def,
        // poisson,
        // h2hCompare,
        // goals,
        // total,
      ];

  Map<String, dynamic> toMap() {
    return {
      'h2h': h2h.map((e) => (e as FootballMatchModel).toJson()).toList(),
    };
  }

  factory Predict.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> compareMap = map['comparison'];
    Map<String, dynamic> predictMap = map['predictions'];
    Map<String, dynamic> teamsMap = map['teams'];

    return Predict(
      predictions: Predictions.fromMap(predictMap['percent']),
      // form: compareMap['form'],
      // att: compareMap['att'],
      // def: compareMap['def'],
      // poisson: compareMap['poisson_distribution'],
      // h2hCompare: compareMap['h2h'],
      // goals: compareMap['goals'],
      // total: compareMap['total'],

      home: TeamStat.fromMap(teamsMap['home']),
      away: TeamStat.fromMap(teamsMap['away']),
      h2h: (map['h2h'] as List<dynamic>)
          .map((e) => FootballMatchModel.fromJson(e))
          .toList(),
    );
  }
}
