import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team.dart';
import 'package:soccer_sport/standings/domain/entities/score.dart';

class Standing extends Equatable {
  final int rank;
  final Team team;
  final int points;
  final int goalsDiff;
  final String group;
  final String? form;
  final String? status;
  final String? description;
  final String? update;
  final Score all;
  final Score home;
  final Score away;
  Standing({
    required this.rank,
    required this.team,
    required this.points,
    required this.goalsDiff,
    required this.group,
    this.form,
    this.status,
    this.description,
    this.update,
    required this.all,
    required this.home,
    required this.away,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  @override
  List<Object?> get props => [
        rank,
        team,
        points,
        goalsDiff,
        group,
        form,
        status,
        description,
        update,
        all,
        home,
        away,
      ];
}
