import 'package:equatable/equatable.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class Compare extends Equatable {
  String home;
  String away;

  Compare({required this.home, required this.away});

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [home, away];

  Map<String, dynamic> toMap() {
    return {
      'home': home,
      'away': away,
    };
  }

  factory Compare.fromMap(Map<String, dynamic> map) {
    var value = 0;

    return Compare(
      home: map['home'],
      away: map['away'],
    );
  }
}
