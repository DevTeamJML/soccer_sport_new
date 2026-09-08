part of 'league_bloc.dart';

abstract class LeagueState extends Equatable {
  const LeagueState();

  @override
  List<Object> get props => [];
}

class LeagueInitial extends LeagueState {}

class LoadLeagues extends LeagueState {}

class LeaguesLoaded extends LeagueState {
  final List<LeagueDetails> leagues;

  LeaguesLoaded({required this.leagues});

  @override
  List<Object> get props => [leagues];
}

class LoadLeague extends LeagueState {}

class LeagueLoaded extends LeagueState {
  final League leagues;

  LeagueLoaded({required this.leagues});

  @override
  List<Object> get props => [leagues];
}

class LeaguesError extends LeagueState {
  final String message;

  LeaguesError({required this.message});

  @override
  List<Object> get props => [message];
}

class PersistLeaguesError extends LeagueState {
  final String message;

  PersistLeaguesError({required this.message});

  @override
  List<Object> get props => [message];
}

//local

class LoadPersistedLeagues extends LeagueState {}

class PersistedLeaguesLoaded extends LeagueState {
  final List<LeagueDetails> leagues;

  PersistedLeaguesLoaded({required this.leagues});

  @override
  List<Object> get props => [leagues];
}

class PersistLeagues extends LeagueState {}

class PersistLeaguesSuccess extends LeagueState {
  final bool success;

  PersistLeaguesSuccess({required this.success});

  @override
  List<Object> get props => [success];
}

class CheckLeagues extends LeagueState {}

class LeaguesMatched extends LeagueState {
  final bool success;

  LeaguesMatched({required this.success});

  @override
  List<Object> get props => [success];
}

class LoadUpdateDate extends LeagueState {}

class UpdatedDateLoaded extends LeagueState {
  final String date;

  UpdatedDateLoaded({required this.date});

  @override
  List<Object> get props => [date];
}

class PersistUpdateDateLoading extends LeagueState {}

class PersistUpdateDateSuccess extends LeagueState {
  final bool success;

  PersistUpdateDateSuccess({required this.success});

  @override
  List<Object> get props => [success];
}

class LoadTeamSeason extends LeagueState {}

class TeamSeasonLoaded extends LeagueState {
  final List<LeagueDetails> success;

  TeamSeasonLoaded({required this.success});

  @override
  List<Object> get props => [success];
}

class SeasonLoaded extends LeagueState {}
