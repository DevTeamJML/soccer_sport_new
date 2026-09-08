import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/topscore/data/datasources/top_score_api.dart';
import 'package:soccer_sport/topscore/domain/entities/top_score.dart';
import 'package:soccer_sport/topscore/domain/repositories/top_score_repositories.dart';

class TopScoreRepositoryImpl implements TopScoreRepository {
  final TopScoreApiDataSource apiDataSource;
  // final ArticleLocalDataSource localDataSource;

  TopScoreRepositoryImpl({
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
  Future<Either<Failure, List<TopScore>>> getTopScoreByLeague(
      String id, String season) async {
    try {
      final topScore = await apiDataSource.getTopScoreByLeague(id, season);
      return Right(topScore);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
