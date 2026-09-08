import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';

class MatchByDate extends Equatable {
  DateTime date;
  List<FootballMatch> matches;
  MatchByDate({required this.date, required this.matches});

  @override
  List<Object?> get props => [
        date,
        matches,
      ];
}
