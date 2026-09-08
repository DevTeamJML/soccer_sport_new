part of 'football_match_bloc.dart';

abstract class FootballMatchState extends Equatable {
  const FootballMatchState();

  @override
  List<Object?> get props => [];
}

class FootballMatchInitial extends FootballMatchState {}

class LoadAllFootballMatch extends FootballMatchState {}

class FootballMatchesLoaded extends FootballMatchState {
  final List<FootballMatch> footballMatches;

  FootballMatchesLoaded({required this.footballMatches});

  @override
  List<Object> get props => [footballMatches];
}

class FootballMatchesError extends FootballMatchState {
  final String message;

  FootballMatchesError({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadAllIncomingFootballMatch extends FootballMatchState {}

class IncomingFootballMatchesLoaded extends FootballMatchState {
  final List<FootballMatch> footballMatches;

  IncomingFootballMatchesLoaded({required this.footballMatches});

  @override
  List<Object> get props => [footballMatches];
}

class IncomingFootballMatchesError extends FootballMatchState {
  final String message;

  IncomingFootballMatchesError({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadCurrentRoundFixtures extends FootballMatchState {}

class CurrentRoundFixturesLoaded extends FootballMatchState {
  final List<FootballMatch> footballMatches;
  final String currentRound;
  CurrentRoundFixturesLoaded(
      {required this.footballMatches, required this.currentRound});

  @override
  List<Object> get props => [footballMatches];
}

class LoadFixtureRounds extends FootballMatchState {}

class FixtureRoundsLoaded extends FootballMatchState {
  final List<String> footballMatches;

  FixtureRoundsLoaded({required this.footballMatches});

  @override
  List<Object> get props => [footballMatches];
}

class LoadFixturesCurrentRound extends FootballMatchState {}

class FixturesCurrentRoundLoaded extends FootballMatchState {
  final String footballMatches;

  FixturesCurrentRoundLoaded({required this.footballMatches});

  @override
  List<Object> get props => [footballMatches];
}

class CheckingFixtureOnLive extends FootballMatchState {}

class FixtureOnLiveChecked extends FootballMatchState {
  final FootballMatch? footballMatches;

  FixtureOnLiveChecked({required this.footballMatches});

  @override
  List<Object?> get props => [footballMatches];
}

class LoadIncomingLiveMatch extends FootballMatchState {}

class IncomingLiveMatchLoaded extends FootballMatchState {
  final List<FootballMatch>? footballMatches;

  IncomingLiveMatchLoaded({required this.footballMatches});

  @override
  List<Object?> get props => [footballMatches];
}

class LoadGetFixtureBetweenDates extends FootballMatchState {}

class GetFixtureBetweenDatesLoaded extends FootballMatchState {
  final List<FootballMatch>? footballMatches;

  GetFixtureBetweenDatesLoaded({required this.footballMatches});

  @override
  List<Object?> get props => [footballMatches];
}

class GettingAllMatchByLeague extends FootballMatchState {}

class AllMatchByLeagueGet extends FootballMatchState {
  final List<FootballMatch> footballMatches;

  AllMatchByLeagueGet({required this.footballMatches});

  @override
  List<Object> get props => [footballMatches];
}

class GettingBetLog extends FootballMatchState {}

class BetLogGet extends FootballMatchState {
  final List<List<Bet>> bet;

  BetLogGet({required this.bet});

  @override
  List<Object> get props => [bet];
}

class UpdatingBet extends FootballMatchState {}

class BetUpdated extends FootballMatchState {
  final List<List<Bet>> bet;

  BetUpdated({required this.bet});

  @override
  List<Object> get props => [bet];
}

class BetWonUpdating extends FootballMatchState {}

class BetWonUpdated extends FootballMatchState {
  final bool bet;

  BetWonUpdated({required this.bet});

  @override
  List<Object> get props => [bet];
}

class BetFixtureFail extends FootballMatchState {}

class CheckingMatchTutorial extends FootballMatchState {}

class MatchTutorialChecked extends FootballMatchState {
  final bool bet;

  MatchTutorialChecked({required this.bet});

  @override
  List<Object> get props => [bet];
}

class PersistingMatchTutorial extends FootballMatchState {}

class MatchTutorialPersisted extends FootballMatchState {
  final bool bet;

  MatchTutorialPersisted({required this.bet});

  @override
  List<Object> get props => [bet];
}

class LoadingBetRank extends FootballMatchState {}

class BetRankLoaded extends FootballMatchState {
  final List<BetRanking> bet;

  BetRankLoaded({required this.bet});

  @override
  List<Object> get props => [bet];
}

class GettingMatchStatsInfo extends FootballMatchState {}

class MatchStatsInfoGet extends FootballMatchState {
  final List<MatchStatsInfo> stats;

  MatchStatsInfoGet({required this.stats});

  @override
  List<Object> get props => [stats];
}

class GettingMatchLineups extends FootballMatchState {}

class MatchLineupsGet extends FootballMatchState {
  final List<MatchLineups> stats;

  MatchLineupsGet({required this.stats});

  @override
  List<Object> get props => [stats];
}

class GettingMatchInjuries extends FootballMatchState {}

class MatchInjuriesGet extends FootballMatchState {
  final List<MatchInjuries> stats;

  MatchInjuriesGet({required this.stats});

  @override
  List<Object> get props => [stats];
}

class GettingMatchEvent extends FootballMatchState {}

class MatchEventGet extends FootballMatchState {
  final List<Event> stats;

  MatchEventGet({required this.stats});

  @override
  List<Object> get props => [stats];
}

class GettingMatchPredict extends FootballMatchState {}

class MatchPredictGet extends FootballMatchState {
  final Predict stats;

  MatchPredictGet({required this.stats});

  @override
  List<Object> get props => [stats];
}

class LoadFixturesByTeam extends FootballMatchState {}

class FixturesByTeamLoaded extends FootballMatchState {
  final List<FootballMatch> match;

  FixturesByTeamLoaded({required this.match});

  @override
  List<Object> get props => [match];
}

class LoadPlayerStatsInfo extends FootballMatchState {}

class PlayerStatsInfoLoaded extends FootballMatchState {
  final List<PlayerStatsInfoV2> match;

  PlayerStatsInfoLoaded({required this.match});

  @override
  List<Object> get props => [match];
}
