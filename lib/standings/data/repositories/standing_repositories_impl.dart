import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/league/data/datasources/league_api.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';
import 'package:soccer_sport/standings/data/datasources/standing_api.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/repositories/standing_repositories.dart';

class StandingRepositoryImpl implements StandingRepository {
  final StandingApiDataSource apiDataSource;
  // final ArticleLocalDataSource localDataSource;

  StandingRepositoryImpl({
    required this.apiDataSource,
    // required this.localDataSource,
  });

  @override
  // Future<Either<Failure, List<LeagueDetails>>> getAllLeague() async {
  //   try {
  //     final leagues = await apiDataSource.getAllLeague();

  //     return Right(leagues);
  //   } on ServerException {
  //     return Left(ServerFailure());
  //   }
  // }

  @override
  Future<Either<Failure, LeagueStandings?>> getStandingByLeague(
      String id, int season) async {
    try {
      final leagues = await apiDataSource.getStandingByLeague(id, season);

      return Right(leagues);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeagueStandings>>> getStandingByTeam(
      String id, int season) async {
    try {
      final leagues = await apiDataSource.getStandingByTeam(id, season);

      return Right(leagues);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
