// factory Fixture.fromJson(Map<String, dynamic> json) {
//     return Fixture(json['id'], json['date'], Status.fromJson(json['status']));
//   }

import 'package:soccer_sport/footballMatch/data/model/status_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/fixture.dart';

class FixtureModel extends Fixture {
  FixtureModel({
    required int id,
    required String date,
    int? timeStamp,
    required StatusModel status,
    String? timeZone,
    String? referee,
  }) : super(
          id: id,
          date: date,
          status: status,
          timeStamp: timeStamp,
          timeZone: timeZone,
          referee: referee,
        );

  factory FixtureModel.fromJson(Map<String, dynamic> json) {
    return FixtureModel(
      id: json['id'],
      date: json['date'],
      timeZone: json['timeZone'],
      referee: json['referee'],
      timeStamp: json['timeStamp'],
      status: StatusModel.fromJson(json['status']),
    );
  }

  FixtureModel.fromEntity(Fixture fixtureModel)
      : super(
          id: fixtureModel.id,
          date: fixtureModel.date,
          timeStamp: fixtureModel.timeStamp,
          status: fixtureModel.status,
          timeZone: fixtureModel.timeZone,
          referee: fixtureModel.referee,
        );
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'status': StatusModel.fromEntity(status).toJson(),
      'timeStamp': timeStamp,
      'timeZone': timeZone,
      'referee': referee,
    };
  }
}
