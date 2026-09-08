import 'package:equatable/equatable.dart';
import 'package:soccer_sport/league/domain/entities/country.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/season.dart';
import 'package:azlistview/azlistview.dart';

class LeagueDetails extends Equatable with ISuspensionBean {
  final League league;
  final Country? country;
  final List<Season>? seasons;

  // final int seasons;
  LeagueDetails({
    required this.league,
    this.country,
    this.seasons,
    // required this.season,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  @override
  List<Object?> get props => [
        league,
        country,
        seasons
        // season,
      ];

  @override
  String getSuspensionTag() {
    return country!.name;
  }
}
