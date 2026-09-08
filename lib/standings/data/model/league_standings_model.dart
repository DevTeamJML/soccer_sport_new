import 'package:soccer_sport/standings/data/model/standing_model.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';

class LeagueStandingsModel extends LeagueStandings {
  LeagueStandingsModel({
    int? id,
    String? name,
    String? country,
    String? logo,
    String? flag,
    int? season,
    required List<StandingModel> standings,
  }) : super(
          id: id,
          name: name,
          country: country,
          logo: logo,
          flag: flag,
          season: season,
          standings: standings,
        );

  factory LeagueStandingsModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> standingList = json['standings'];
    List<dynamic> combineStandings =
        standingList.expand((element) => element).toList();
    return LeagueStandingsModel(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      logo: json['logo'],
      flag: json['flag'],
      season: json['season'],
      standings:
          combineStandings.map((e) => StandingModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'logo': logo,
      'flag': flag,
      'season': season,
      'standings': standings,
    };
  }
}
