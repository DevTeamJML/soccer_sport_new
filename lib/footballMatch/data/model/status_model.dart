// factory Fixture.fromJson(Map<String, dynamic> json) {
//     return Fixture(json['id'], json['date'], Status.fromJson(json['status']));
//   }

import 'package:soccer_sport/footballMatch/domain/entities/status.dart';

class StatusModel extends Status {
  StatusModel({
    int? elapsedTime,
    String? short,
    String? long,
  }) : super(
          elapsedTime: elapsedTime,
          long: long,
          short: short,
        );

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      elapsedTime: json['elapsed'],
      long: json['long'],
      short: json['short'],
    );
  }

  StatusModel.fromEntity(Status statusModel)
      : super(
          elapsedTime: statusModel.elapsedTime,
          short: statusModel.short,
          long: statusModel.long,
        );
  Map<String, dynamic> toJson() {
    return {
      'elapsed': elapsedTime,
      'long': long,
      'short': short,
    };
  }
}
