import 'package:soccer_sport/league/data/model/coverage_model.dart';
import 'package:soccer_sport/league/domain/entities/season.dart';

class SeasonModel extends Season {
  SeasonModel({
    required int year,
    String? start,
    String? end,
    bool? current,
    CoverageModel? coverage,
    // required int seasons,
  }) : super(
          year: year,
          start: start,
          end: end,
          current: current,
          coverage: coverage,
          // season: season,
        );

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      year: json['year'],
      start: json['start'],
      end: json['end'],
      current: json['current'],
      coverage: CoverageModel.fromJson(json['coverage']),
    );
  }

  SeasonModel.fromEntity(Season seasonModel)
      : super(
          year: seasonModel.year,
          start: seasonModel.start,
          end: seasonModel.end,
          current: seasonModel.current,
          coverage: seasonModel.coverage,
        );
  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'start': start,
      'end': end,
      'current': current,
      'coverage': CoverageModel.fromEntity(coverage!).toJson(),
    };
  }
}
