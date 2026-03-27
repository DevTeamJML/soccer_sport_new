import 'package:soccer_sport/league/domain/entities/country.dart';
import 'package:soccer_sport/league/domain/entities/fixtures.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/standings/data/model/standing_model.dart';

class FixturesModel extends Fixtures {
  FixturesModel({
    bool? event,
    bool? lineups,
    bool? statisticsFixtures,
    bool? statisticsPlayers,
    // required int seasons,
  }) : super(
          event: event,
          lineups: lineups,
          statisticsFixtures: statisticsFixtures,
          statisticsPlayers: statisticsPlayers,
          // season: season,
        );

  factory FixturesModel.fromJson(Map<String, dynamic> json) {
    return FixturesModel(
      event: json['event'],
      lineups: json['lineups'],
      statisticsFixtures: json['statistics_fixtures'],
      statisticsPlayers: json['statistics_players'],
      // season: json['season'],
    );
  }

  FixturesModel.fromEntity(Fixtures fixturesModel)
      : super(
          event: fixturesModel.event,
          lineups: fixturesModel.lineups,
          statisticsFixtures: fixturesModel.statisticsFixtures,
          statisticsPlayers: fixturesModel.statisticsPlayers,
        );
  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'lineups': lineups,
      'statisticsFixtures': statisticsFixtures,
      'statisticsPlayers': statisticsPlayers,
    };
  }
}
