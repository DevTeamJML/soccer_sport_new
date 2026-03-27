import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/footballMatch/data/datasources/football_match_api.dart';
import 'package:soccer_sport/footballMatch/data/datasources/football_match_local.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_ranking/bet_ranking.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_injuries.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_lineups.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_stats_info.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/predict.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

import '../../domain/entities/team_info/player_stats_info_v2.dart';

class FootballMatchRepositoryImpl implements FootballMatchRepository {
  final FootballMatchApiDataSource apiDataSource;

  final FootballMatchLocalDataSource localDataSource;

  FootballMatchRepositoryImpl({
    required this.apiDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<FootballMatch>>> getAllMatch() async {
    try {
      final footballMatches = await apiDataSource.getAllMatch();

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FootballMatch>>> getAllIncomingMatch() async {
    try {
      final footballMatches = await apiDataSource.getAllIncomingMatch();

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FootballMatch>>> getFixturesByLeague(
      String id, String season) async {
    try {
      final footballMatches =
          await apiDataSource.getFixturesByLeague(id, season);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  //Local

  @override
  Future<Either<Failure, List<FootballMatch>>> getIncomingFixturesByLeague(
      String id, String season) async {
    try {
      final footballMatches =
          await apiDataSource.getIncomingFixturesByLeague(id, season);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FootballMatch>>> getFixtureByRound(
      String round, String id, String season) async {
    try {
      final footballMatches =
          await apiDataSource.getFixtureByRound(round, id, season);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFixtureRounds(
      String id, String season) async {
    try {
      final footballMatches = await apiDataSource.getFixtureRounds(id, season);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getFixturesCurrentRound(
      String id, String season) async {
    try {
      final footballMatches =
          await apiDataSource.getFixturesCurrentRound(id, season);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, FootballMatch?>> checkFixtureOnLive(
      FootballMatch ongoingMatch) async {
    try {
      final footballMatches = await apiDataSource
          .checkFixtureOnLive(ongoingMatch as FootballMatchModel);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FootballMatch>?>> getIncomingLiveMatch() async {
    try {
      final footballMatches = await apiDataSource.getIncomingLiveMatch();

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FootballMatch>>> getFixtureBetweenDates(
      List<String> ids) async {
    try {
      final footballMatches = await apiDataSource.getFixtureBetweenDates(
        ids,
      );

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FootballMatch>>> getAllMatchByLeague(
      String id, String season) async {
    try {
      final footballMatches =
          await apiDataSource.getAllMatchByLeague(id, season);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<List<Bet>>>> getBetLog(String id) async {
    try {
      final footballMatches = await apiDataSource.getBetLog(id);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<List<Bet>>>> updateBet(
      String id, List<Bet> bet, List<Bet> betLog) async {
    try {
      final footballMatches = await apiDataSource.updateBet(id, bet, betLog);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> betWonUpdate(
      String id, int value, List<String> data) async {
    try {
      final footballMatches = await apiDataSource.betWonUpdate(id, value, data);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<List<Bet>>>> updateFinishedBet(
      String id, List<Bet> bet, List<Bet> betLog) async {
    try {
      final footballMatches =
          await apiDataSource.updateFinishedBet(id, bet, betLog);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    } on NotEnugCoin {
      return Left(NotEnugCoinFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkMatchTutorial() async {
    try {
      final footballMatches = await localDataSource.checkMatchTutorial();

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    } on NotEnugCoin {
      return Left(NotEnugCoinFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> persistMatchTutorial() async {
    try {
      final footballMatches = await localDataSource.persistMatchTutorial();

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    } on NotEnugCoin {
      return Left(NotEnugCoinFailure());
    }
  }

  @override
  Future<Either<Failure, List<BetRanking>>> getBetRanking() async {
    try {
      final footballMatches = await apiDataSource.getBetRanking();

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    } on NotEnugCoin {
      return Left(NotEnugCoinFailure());
    }
  }

  @override
  Future<Either<Failure, List<MatchStatsInfo>>> getMatchStatsInfo(
      String id) async {
    try {
      final footballMatches = await apiDataSource.getMatchStatsInfo(id);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    } on NotEnugCoin {
      return Left(NotEnugCoinFailure());
    }
  }

  @override
  Future<Either<Failure, List<MatchLineups>>> getMatchLineups(String id) async {
    try {
      final footballMatches = await apiDataSource.getMatchLineups(id);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MatchInjuries>>> getMatchInjuries(
      String id) async {
    try {
      final footballMatches = await apiDataSource.getMatchInjuries(id);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getMatchEvent(String id) async {
    try {
      final footballMatches = await apiDataSource.getMatchEvent(id);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Predict>> getMatchPredict(String id) async {
    try {
      final footballMatches = await apiDataSource.getMatchPredict(id);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FootballMatch>>> getFixturesByTeam(
      String id, String season) async {
    try {
      final footballMatches = await apiDataSource.getFixturesByTeam(id, season);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PlayerStatsInfoV2>>> getPlayerStatsInfo(
      String id, String season) async {
    try {
      final footballMatches =
          await apiDataSource.getPlayerStatsInfo(id, season);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
