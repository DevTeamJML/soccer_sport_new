import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/league/data/datasources/league_api.dart';
import 'package:soccer_sport/league/data/datasources/league_local.dart';
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

class LeagueRepositoryImpl implements LeagueRepository {
  final LeagueApiDataSource apiDataSource;
  final LeagueLocalDataSource localDataSource;

  // final ArticleLocalDataSource localDataSource;

  LeagueRepositoryImpl({
    required this.apiDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<LeagueDetails>>> getAllLeague() async {
    try {
      final leagues = await apiDataSource.getAllLeague();

      return Right(leagues);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, League>> getLeagueByName(String name) async {
    try {
      final leagues = await apiDataSource.getLeagueByName(name);

      return Right(leagues);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkLocalLeagues(
      List<LeagueDetails> list) async {
    try {
      final leagues = await localDataSource
          .checkLocalLeagues(list as List<LeagueDetailsModel>);

      return Right(leagues);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeagueDetails>>> getLocalLeagues() async {
    try {
      final leagues = await localDataSource.getLocalLeagues();

      return Right(leagues);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> persistLocalLeagues(
      List<LeagueDetails> list) async {
    try {
      final leagues = await localDataSource
          .persistLocalLeagues(list as List<LeagueDetailsModel>);

      return Right(leagues);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getUpdateDate() async {
    try {
      final leagues = await localDataSource.getUpdateDate();

      return Right(leagues);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> persistUpdateDate(String date) async {
    try {
      final leagues = await localDataSource.persistUpdateDate(date);

      return Right(leagues);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeagueDetails>>> getTeamSeason(String id) async {
    try {
      final leagues = await apiDataSource.getTeamSeason(id);

      return Right(leagues);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
