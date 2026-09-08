import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/standings/data/model/standing_model.dart';

class LeagueModel extends League {
  LeagueModel({
    required int id,
    required String name,
    String? type,
    String? country,
    String? logo,
    String? round,
    int? seasons,
  }) : super(
          id: id,
          name: name,
          type: type,
          logo: logo,
          round: round,
          country: country,
          seasons: seasons,
          // season: season,
        );

  factory LeagueModel.fromJson(Map<String, dynamic> json) {
    return LeagueModel(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      type: json['type'],
      logo: json['logo'],
      round: json['round'],
      seasons: json['season'] != null ? json['season'] : null,
      // season: json['season'],
    );
  }

  LeagueModel.fromEntity(League leagueModel)
      : super(
          id: leagueModel.id,
          name: leagueModel.name,
          country: leagueModel.country,
          type: leagueModel.type,
          logo: leagueModel.logo,
          round: leagueModel.round,
          seasons: leagueModel.seasons,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'logo': logo,
      'round': round,
      'country': country,
      if (seasons != null) 'season': seasons,
    };
  }
}
