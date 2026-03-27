part of 'league_bloc.dart';

abstract class LeagueEvent extends Equatable {
  const LeagueEvent();

  @override
  List<Object> get props => [];
}

class GetAllLeagueRequest extends LeagueEvent {}

class GetLeagueByNameRequest extends LeagueEvent {
  final String name;

  GetLeagueByNameRequest({required this.name});

  @override
  List<Object> get props => [name];
}

class GetLocalLeaguesRequest extends LeagueEvent {}

class PersistLocalLeaguesRequest extends LeagueEvent {
  final List<LeagueDetails> leagues;

  PersistLocalLeaguesRequest({required this.leagues});

  @override
  List<Object> get props => [leagues];
}

class CheckLocalLeaguesRequest extends LeagueEvent {
  final List<LeagueDetails> leagues;

  CheckLocalLeaguesRequest({required this.leagues});

  @override
  List<Object> get props => [leagues];
}

class PersistUpdateDateRequest extends LeagueEvent {
  final String date;

  PersistUpdateDateRequest({required this.date});

  @override
  List<Object> get props => [date];
}

class GetTeamSeasonRequest extends LeagueEvent {
  final String id;

  GetTeamSeasonRequest({required this.id});

  @override
  List<Object> get props => [id];
}

class GetUpdateDateRequest extends LeagueEvent {}

class ChangeSeasonRequest extends LeagueEvent {}
