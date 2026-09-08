import 'package:equatable/equatable.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class Predictions extends Equatable {
  double home;
  double draw;
  double away;

  Predictions({required this.home, required this.draw, required this.away});

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [home, draw, away];

  Map<String, dynamic> toMap() {
    return {
      'home': home,
      'draw': draw,
      'away': away,
    };
  }

  factory Predictions.fromMap(Map<String, dynamic> map) {
    return Predictions(
      home: double.parse((map['home'] as String).replaceAll("%", "")),
      draw: double.parse((map['draw'] as String).replaceAll("%", "")),
      away: double.parse((map['away'] as String).replaceAll("%", "")),
    );
  }
}
