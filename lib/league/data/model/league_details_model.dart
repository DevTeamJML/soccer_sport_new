import 'package:soccer_sport/league/data/model/country_model.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/data/model/season_model.dart';
import 'package:soccer_sport/league/domain/entities/country.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/entities/season.dart';

class LeagueDetailsModel extends LeagueDetails {
  LeagueDetailsModel({
    required League league,
    Country? country,
    List<Season>? seasons,
  }) : super(
          league: league,
          country: country,
          seasons: seasons,
        );

  factory LeagueDetailsModel.fromJson(Map<String, dynamic> json) {
    return LeagueDetailsModel(
      league: LeagueModel.fromJson(json['league']),
      country: CountryModel.fromJson(json['country']),
      seasons: (json['seasons'] as List)
          .map((e) => SeasonModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'league': LeagueModel.fromEntity(league).toJson(),
      'country': CountryModel.fromEntity(country!).toJson(),
      'seasons':
          seasons!.map((e) => SeasonModel.fromEntity(e).toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        league,
        country,
        seasons
        // season,
      ];
}
