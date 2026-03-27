part of 'football_match_bloc.dart';

abstract class FootballMatchEvent extends Equatable {
  const FootballMatchEvent();

  @override
  List<Object> get props => [];
}

class GetAllMatchRequest extends FootballMatchEvent {}

class GetFixturesByLeagueRequest extends FootballMatchEvent {
  final String leagueId;
  final String season;

  GetFixturesByLeagueRequest({required this.leagueId, required this.season});

  @override
  List<Object> get props => [leagueId, season];
}

class GetIncomingFixturesByLeagueRequest extends FootballMatchEvent {
  final String leagueId;
  final String season;

  GetIncomingFixturesByLeagueRequest(
      {required this.leagueId, required this.season});

  @override
  List<Object> get props => [leagueId, season];
}

class GetAllIncomingMatchRequest extends FootballMatchEvent {}

class GetFixtureByRoundRequest extends FootballMatchEvent {
  final String round;
  final String leagueId;
  final String season;

  GetFixtureByRoundRequest(
      {required this.round, required this.leagueId, required this.season});

  @override
  List<Object> get props => [round, leagueId, season];
}

class GetFixtureRoundRequest extends FootballMatchEvent {
  final String leagueId;
  final String season;

  GetFixtureRoundRequest({required this.leagueId, required this.season});

  @override
  List<Object> get props => [leagueId, season];
}

class GetFixturesCurrentRoundRequest extends FootballMatchEvent {
  final String leagueId;
  final String season;

  GetFixturesCurrentRoundRequest(
      {required this.leagueId, required this.season});

  @override
  List<Object> get props => [leagueId, season];
}

class CheckFixtureOnLiveRequest extends FootballMatchEvent {
  final FootballMatch match;

  CheckFixtureOnLiveRequest({required this.match});

  @override
  List<Object> get props => [match];
}

class GetIncomingLiveMatchRequest extends FootballMatchEvent {}

class GetFixtureBetweenDatesRequest extends FootballMatchEvent {
  final List<String> ids;

  GetFixtureBetweenDatesRequest({required this.ids});

  @override
  List<Object> get props => [ids];
}

class GetAllMatchByLeagueRequest extends FootballMatchEvent {
  final String leagueId;
  final String season;

  GetAllMatchByLeagueRequest({required this.leagueId, required this.season});

  @override
  List<Object> get props => [leagueId, season];
}

class GetBetLogRequest extends FootballMatchEvent {
  final String id;

  GetBetLogRequest({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class UpdateBetRequest extends FootballMatchEvent {
  final String id;
  final List<Bet> bet;
  final List<Bet> betLog;

  UpdateBetRequest({required this.id, required this.bet, required this.betLog});

  @override
  List<Object> get props => [id, bet, betLog];
}

class UpdateFinishedBetRequest extends FootballMatchEvent {
  final String id;
  final List<Bet> bet;
  final List<Bet> betLog;

  UpdateFinishedBetRequest(
      {required this.id, required this.bet, required this.betLog});

  @override
  List<Object> get props => [id, bet, betLog];
}

class BetWonUpdateRequest extends FootballMatchEvent {
  final String id;
  final int value;
  final List<String> data;

  BetWonUpdateRequest(
      {required this.id, required this.value, required this.data});

  @override
  List<Object> get props => [id, value, data];
}

class CheckMatchTutorialRequest extends FootballMatchEvent {}

class PersistMatchTutorialRequest extends FootballMatchEvent {}

class GetBetRankingRequest extends FootballMatchEvent {}

class GetMatchStatsInfoRequest extends FootballMatchEvent {
  final String id;

  GetMatchStatsInfoRequest({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class GetMatchLineupsRequest extends FootballMatchEvent {
  final String id;

  GetMatchLineupsRequest({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class GetMatchInjuriesRequest extends FootballMatchEvent {
  final String id;

  GetMatchInjuriesRequest({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class GetMatchEventRequest extends FootballMatchEvent {
  final String id;

  GetMatchEventRequest({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class GetMatchPredictRequest extends FootballMatchEvent {
  final String id;

  GetMatchPredictRequest({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class GetFixtureByTeamRequest extends FootballMatchEvent {
  final String id;
  final String season;

  GetFixtureByTeamRequest({
    required this.id,
    required this.season,
  });

  @override
  List<Object> get props => [id, season];
}

class GetPlayerStatsInfoRequest extends FootballMatchEvent {
  final String id;
  final String season;

  GetPlayerStatsInfoRequest({
    required this.id,
    required this.season,
  });

  @override
  List<Object> get props => [id, season];
}
