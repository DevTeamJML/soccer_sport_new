import 'package:soccer_sport/league/data/model/fixtures_model.dart';
import 'package:soccer_sport/league/domain/entities/country.dart';
import 'package:soccer_sport/league/domain/entities/coverage.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/standings/data/model/standing_model.dart';

class CoverageModel extends Coverage {
  CoverageModel({
    FixturesModel? fixtures,
    bool? standings,
    bool? players,
    bool? topScores,
    bool? topAssits,
    bool? topCards,
    bool? injuries,
    bool? predictions,
    bool? odds,
    // required int seasons,
  }) : super(
          fixtures: fixtures,
          standings: standings,
          players: players,
          topScores: topScores,
          topAssits: topAssits,
          topCards: topCards,
          injuries: injuries,
          predictions: predictions,
          odds: odds,
          // season: season,
        );

  factory CoverageModel.fromJson(Map<String, dynamic> json) {
    return CoverageModel(
      fixtures: FixturesModel.fromJson(json['fixtures']),
      standings: json['standings'],
      players: json['players'],
      topScores: json['top_scores'],
      topAssits: json['top_assits'],
      topCards: json['top_cards'],
      injuries: json['injuries'],
      predictions: json['predictions'],
      odds: json['odds'],

      // season: json['season'],
    );
  }

  CoverageModel.fromEntity(Coverage coverageModel)
      : super(
          fixtures: coverageModel.fixtures,
          standings: coverageModel.standings,
          players: coverageModel.players,
          topScores: coverageModel.topScores,
          topAssits: coverageModel.topAssits,
          topCards: coverageModel.topCards,
          injuries: coverageModel.injuries,
          predictions: coverageModel.predictions,
          odds: coverageModel.odds,
        );

  Map<String, dynamic> toJson() {
    return {
      'fixtures': FixturesModel.fromEntity(fixtures!).toJson(),
      'standings': standings,
      'players': players,
      'topScores': topScores,
      'topAssits': topAssits,
      'topCards': topCards,
      'injuries': injuries,
      'predictions': predictions,
      'odds': odds,
    };
  }
}
