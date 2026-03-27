import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';

class LiveMatch extends Equatable {
  //here we will see the different data
  //you will find every thing you need in the doc
  //I'm not going to use every data, just few ones

  String league;
  List<FootballMatch> footballMatch;
  bool live;

  LiveMatch({
    required this.league,
    required this.footballMatch,
    required this.live,
  });

  @override
  List<Object?> get props => [league, live, league];
  // factory SoccerMatch.fromJson(Map<String, dynamic> json) {
  //   return SoccerMatch(
  //       Fixture.fromJson(json['fixture']),
  //       Team.fromJson(json['teams']['home']),
  //       Team.fromJson(json['teams']['away']),
  //       Goal.fromJson(json['goals']));
  // }
}
