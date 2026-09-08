part of 'standing_bloc.dart';

abstract class StandingEvent extends Equatable {
  const StandingEvent();

  @override
  List<Object> get props => [];
}

class GetStandingsByLeagueRequest extends StandingEvent {
  final String id;
  final int season;
  GetStandingsByLeagueRequest({required this.id, required this.season});

  @override
  List<Object> get props => [id, season];
}

class GetStandingByTeamRequest extends StandingEvent {
  final String id;
  final int season;
  GetStandingByTeamRequest({required this.id, required this.season});

  @override
  List<Object> get props => [id, season];
}
