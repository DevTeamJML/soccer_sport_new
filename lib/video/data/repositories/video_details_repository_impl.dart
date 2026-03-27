import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/topscore/data/datasources/top_score_api.dart';
import 'package:soccer_sport/topscore/domain/entities/top_score.dart';
import 'package:soccer_sport/topscore/domain/repositories/top_score_repositories.dart';
import 'package:soccer_sport/video/domain/entities/video_details.dart';
import 'package:soccer_sport/video/domain/repositories/video_details_repository.dart';

import '../datasources/video_details_api.dart';

class VideoDetailsRepositoryImpl implements VideoDetailsRepository {
  final VideoDetailsApiDataSource apiDataSource;
  // final ArticleLocalDataSource localDataSource;

  VideoDetailsRepositoryImpl({
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
  Future<Either<Failure, List<VideoDetails>>> getRecentFeed() async {
    try {
      final video = await apiDataSource.getRecentFeed();
      return Right(video);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getYtUrlFromApi(String api) async {
    try {
      final video = await apiDataSource.getYtUrlFromApi(api);
      return Right(video);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkSscLive() async {
    try {
      final video = await apiDataSource.checkSscLive();
      return Right(video);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
