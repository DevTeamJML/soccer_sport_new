import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';
import 'package:soccer_sport/standings/domain/entities/standing.dart';

class LeagueStandings extends Equatable {
  final int? id;
  final String? name;
  final String? country;
  final String? logo;
  final String? flag;
  final int? season;
  final List<Standing> standings;
  LeagueStandings({
    this.id,
    this.name,
    this.country,
    this.logo,
    this.flag,
    this.season,
    required this.standings,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  @override
  List<Object?> get props => [
        id,
        name,
        country,
        logo,
        flag,
        season,
        standings,
      ];
}
