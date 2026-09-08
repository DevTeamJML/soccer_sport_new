import 'package:equatable/equatable.dart';
import 'package:html/parser.dart';
import 'package:soccer_sport/footballMatch/data/model/team_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team.dart';
import 'package:wordpress_api/wordpress_api.dart';

class LeagueTeam extends Equatable {
  final String id;
  final List<Team> team;

  LeagueTeam({
    required this.id,
    required this.team,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  factory LeagueTeam.fromJson(String key, List<Team> team) {
    return LeagueTeam(id: key, team: team);
  }

  Map<String, List<Team>> toJson() {
    return {id: team};
  }

  @override
  List<Object?> get props => [id, team];
}
