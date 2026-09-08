import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/league/data/datasources/league_api.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';
import 'package:soccer_sport/news/data/datasources/news_api.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/repositories/news_repository.dart';
import 'package:soccer_sport/notification/data/datasources/notification_local.dart';
import 'package:soccer_sport/notification/domain/repository/notification_repository.dart';
import 'package:soccer_sport/standings/data/datasources/standing_api.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/repositories/standing_repositories.dart';
import 'package:wordpress_api/wordpress_api.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;
  // final ArticleLocalDataSource localDataSource;

  NotificationRepositoryImpl({
    required this.localDataSource,
    // required this.localDataSource,
  });

  @override
  // Future<Either<Failure, List<LeagueDetails>>> getAllLeague() async {
  //   try {
  //     final leagues = await localDataSource.getAllLeague();

  //     return Right(leagues);
  //   } on ServerException {
  //     return Left(ServerFailure());
  //   }
  // }

  @override
  Future<Either<Failure, bool?>> getNotification() async {
    try {
      final news = await localDataSource.getNotification();

      return Right(news);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> persistNotification(bool notification) async {
    try {
      final news = await localDataSource.persistNotification(notification);

      return Right(news);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeNotification() async {
    try {
      final news = await localDataSource.removeNotification();

      return Right(news);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
