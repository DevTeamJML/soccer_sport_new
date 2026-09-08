import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
import 'package:soccer_sport/footballMatch/domain/entities/fixture.dart';
import 'package:soccer_sport/footballMatch/domain/entities/score.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';

import 'goal.dart';

class FootballMatch extends Equatable {
  //here we will see the different data
  //you will find every thing you need in the doc
  //I'm not going to use every data, just few ones

  Fixture fixture;
  League? league;
  String? round;
  Team home;
  Team away;
  Goal? goal;
  Score? score;
  List<Event>? events;

  FootballMatch(
      {required this.fixture,
      this.league,
      this.round,
      required this.home,
      required this.away,
      this.goal,
      this.score,
      this.events});

  @override
  List<Object?> get props => [fixture, league, home, away, goal, score, events];
  // factory SoccerMatch.fromJson(Map<String, dynamic> json) {
  //   return SoccerMatch(
  //       Fixture.fromJson(json['fixture']),
  //       Team.fromJson(json['teams']['home']),
  //       Team.fromJson(json['teams']['away']),
  //       Goal.fromJson(json['goals']));
  // }

}
