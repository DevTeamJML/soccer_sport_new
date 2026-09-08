import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/favorite_match/data/datasource/favorite_match_local.dart';
import 'package:soccer_sport/favorite_match/domain/repository/favorite_match_repository.dart';
import 'package:soccer_sport/footballMatch/data/datasources/football_match_api.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class FavoriteMatchRepositoryImpl implements FavoriteMatchRepository {
  final FavoriteMatchLocalDataSource localDataSource;

  // final ArticleLocalDataSource localDataSource;

  FavoriteMatchRepositoryImpl({
    required this.localDataSource,
    // required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<FootballMatch>>> getFavoriteMatches() async {
    try {
      final footballMatches = await localDataSource.getFavoriteMatches();

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> persistFavoriteMatch(
      FootballMatch match) async {
    try {
      final footballMatches = await localDataSource.persistFavoriteMatch(match);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeAllFavoriteMatch() async {
    try {
      final footballMatches = await localDataSource.removeAllFavoriteMatch();

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeFavoriteMatch(FootballMatch match) async {
    try {
      final footballMatches = await localDataSource.removeFavoriteMatch(match);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> persistUpdateFavoriteMatch(
      List<FootballMatch> match) async {
    try {
      final footballMatches =
          await localDataSource.persistUpdateFavoriteMatch(match);

      return Right(footballMatches);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
