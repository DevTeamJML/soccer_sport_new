import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team.dart';
import 'package:soccer_sport/standings/domain/entities/goals.dart';

class Score extends Equatable {
  final int? played;
  final int? win;
  final int? draw;
  final int? lose;
  final Goals? goals;

  Score({
    required this.played,
    required this.win,
    required this.draw,
    required this.lose,
    required this.goals,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  @override
  List<Object?> get props => [played, win, draw, lose, goals];
}
