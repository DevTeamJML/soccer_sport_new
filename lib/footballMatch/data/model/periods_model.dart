// factory Fixture.fromJson(Map<String, dynamic> json) {
//     return Fixture(json['id'], json['date'], Status.fromJson(json['status']));
//   }

import 'package:soccer_sport/footballMatch/domain/entities/periods.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';

class PeriodsModel extends Periods {
  PeriodsModel({
    int? first,
    int? second,
  }) : super(
          first: first,
          second: second,
        );

  factory PeriodsModel.fromJson(Map<String, dynamic> json) {
    return PeriodsModel(
      first: json['first'],
      second: json['second'],
    );
  }

  PeriodsModel.fromEntity(PeriodsModel periodsModel)
      : super(
          first: periodsModel.first,
          second: periodsModel.second,
        );

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'second': second,
    };
  }
}
