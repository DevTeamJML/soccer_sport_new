import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/last5_goals.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class Last5 extends Equatable {
  String form;
  String att;
  String def;
  Last5Goals forGoal;
  Last5Goals against;

  Last5(
      {required this.form,
      required this.att,
      required this.def,
      required this.forGoal,
      required this.against});

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [form, att, def, forGoal, against];

  Map<String, dynamic> toMap() {
    return {
      'form': form,
      'att': att,
      'def': def,
      'goals': {
        'for': forGoal,
        'against': against,
      }
    };
  }

  factory Last5.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> goals = map['goals'];
    return Last5(
      form: map['form'],
      att: map['att'],
      def: map['def'],
      forGoal: Last5Goals.fromMap(goals['for']),
      against: Last5Goals.fromMap(goals['against']),
    );
  }
}
