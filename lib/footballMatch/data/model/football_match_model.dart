import 'package:soccer_sport/footballMatch/data/model/fixture_model.dart';
import 'package:soccer_sport/footballMatch/data/model/goal_model.dart';
import 'package:soccer_sport/footballMatch/data/model/team_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';

class FootballMatchModel extends FootballMatch {
  FootballMatchModel({
    required FixtureModel fixture,
    LeagueModel? league,
    String? round,
    required TeamModel home,
    required TeamModel away,
    GoalModel? goal,
    List<Event>? events,
  }) : super(
            fixture: fixture,
            league: league,
            round: round,
            home: home,
            away: away,
            goal: goal,
            events: events);

  factory FootballMatchModel.fromJson(Map<String, dynamic> json) {
    return FootballMatchModel(
      fixture: FixtureModel.fromJson(json['fixture']),
      league: LeagueModel.fromJson(json['league']),
      home: TeamModel.fromJson(json['teams']['home']),
      away: TeamModel.fromJson(json['teams']['away']),
      goal: json['goals'] != null ? GoalModel.fromJson(json['goals']) : null,
      events: json['events'] != null
          ? (json['events'] as List).map((e) => Event.fromJson(e)).toList()
          : null,
    );
  }

  FootballMatchModel.fromEntity(FootballMatch match)
      : super(
            fixture: match.fixture,
            league: match.league,
            round: match.round,
            home: match.home,
            away: match.away,
            goal: match.goal,
            events: match.events);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map['fixture'] = FixtureModel.fromEntity(fixture).toJson();
    map['teams'] = {
      'home': TeamModel.fromEntity(home).toJson(),
      'away': TeamModel.fromEntity(away).toJson(),
    };
    if (league != null)
      map['league'] = LeagueModel.fromEntity(league!).toJson();
    if (goal != null) map['goals'] = GoalModel.fromEntity(goal!).toJson();
    if (events != null && events!.isNotEmpty)
      map['events'] = events!.map((e) => e.toJson()).toList();
    return map;
  }
}
