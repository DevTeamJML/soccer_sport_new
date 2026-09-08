import 'package:soccer_sport/league/domain/entities/country.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/standings/data/model/standing_model.dart';

class CountryModel extends Country {
  CountryModel({
    required String name,
    String? code,
    String? flag,
    // required int seasons,
  }) : super(
          name: name,
          code: code,
          flag: flag,
          // season: season,
        );

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'],
      code: json['code'],
      flag: json['flag'],
      // season: json['season'],
    );
  }

  CountryModel.fromEntity(Country countryModel)
      : super(
          name: countryModel.name,
          code: countryModel.code,
          flag: countryModel.flag,
        );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'flag': flag,
    };
  }
}
