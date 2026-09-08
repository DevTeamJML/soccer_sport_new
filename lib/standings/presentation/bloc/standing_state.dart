part of 'standing_bloc.dart';

abstract class StandingState extends Equatable {
  const StandingState();

  @override
  List<Object?> get props => [];
}

class StandingInitial extends StandingState {}

class LoadStandings extends StandingState {}

class StandingsLoaded extends StandingState {
  final LeagueStandings? standings;

  StandingsLoaded({this.standings});

  @override
  List<Object?> get props => [standings];
}

class LoadStandingByTeam extends StandingState {}

class StandingByTeamLoaded extends StandingState {
  final List<LeagueStandings> standings;

  StandingByTeamLoaded({required this.standings});

  @override
  List<Object> get props => [standings];
}

class StandingsError extends StandingState {
  final String message;

  StandingsError({required this.message});

  @override
  List<Object> get props => [message];
}
