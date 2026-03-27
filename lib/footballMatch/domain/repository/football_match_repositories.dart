import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_ranking/bet_ranking.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_injuries.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_lineups.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_stats_info.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/predict.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_fixture_between_dates.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_injuries.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_lineups.dart';

import '../entities/team_info/player_stats_info.dart';
import '../entities/team_info/player_stats_info_v2.dart';

abstract class FootballMatchRepository {
  Future<Either<Failure, List<FootballMatch>>> getAllMatch();
  Future<Either<Failure, List<FootballMatch>>> getAllIncomingMatch();

  Future<Either<Failure, List<FootballMatch>>> getFixturesByLeague(
      String id, String season);

  Future<Either<Failure, List<FootballMatch>>> getFixtureBetweenDates(
      List<String> ids);

  Future<Either<Failure, List<FootballMatch>>> getIncomingFixturesByLeague(
      String id, String season);

  Future<Either<Failure, List<FootballMatch>>> getAllMatchByLeague(
      String id, String season);
  Future<Either<Failure, List<String>>> getFixtureRounds(
      String id, String season);

  Future<Either<Failure, List<FootballMatch>>> getFixtureByRound(
      String round, String id, String season);

  Future<Either<Failure, String>> getFixturesCurrentRound(
      String id, String season);
  Future<Either<Failure, FootballMatch?>> checkFixtureOnLive(
      FootballMatch ongoingMatch);
  Future<Either<Failure, List<FootballMatch>?>> getIncomingLiveMatch();
  Future<Either<Failure, List<List<Bet>>>> getBetLog(String id);
  Future<Either<Failure, bool>> betWonUpdate(
      String id, int value, List<String> data);

  Future<Either<Failure, List<List<Bet>>>> updateBet(
      String id, List<Bet> bet, List<Bet> betLog);
  Future<Either<Failure, List<List<Bet>>>> updateFinishedBet(
      String id, List<Bet> bet, List<Bet> betLog);
  Future<Either<Failure, bool>> checkMatchTutorial();
  Future<Either<Failure, bool>> persistMatchTutorial();
  Future<Either<Failure, List<BetRanking>>> getBetRanking();
  Future<Either<Failure, List<MatchStatsInfo>>> getMatchStatsInfo(String id);
  Future<Either<Failure, List<MatchLineups>>> getMatchLineups(String id);
  Future<Either<Failure, List<MatchInjuries>>> getMatchInjuries(String id);
  Future<Either<Failure, List<Event>>> getMatchEvent(String id);
  Future<Either<Failure, Predict>> getMatchPredict(String id);
  Future<Either<Failure, List<FootballMatch>>> getFixturesByTeam(
      String id, String season);

  Future<Either<Failure, List<PlayerStatsInfoV2>>> getPlayerStatsInfo(
      String id, String season);
}
