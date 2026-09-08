import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';

abstract class FavoriteMatchRepository {
  Future<Either<Failure, List<FootballMatch>>> getFavoriteMatches();
  Future<Either<Failure, bool>> persistFavoriteMatch(FootballMatch match);
  Future<Either<Failure, bool>> removeFavoriteMatch(FootballMatch match);
  Future<Either<Failure, bool>> removeAllFavoriteMatch();
  Future<Either<Failure, bool>> persistUpdateFavoriteMatch(
      List<FootballMatch> match);
}
