import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/league/data/datasources/league_api.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';
import 'package:soccer_sport/news/data/datasources/news_api.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/entities/news_content.dart';
import 'package:soccer_sport/news/domain/repositories/news_repository.dart';
import 'package:soccer_sport/standings/data/datasources/standing_api.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/repositories/standing_repositories.dart';
import 'package:wordpress_api/wordpress_api.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiDataSource apiDataSource;
  // final ArticleLocalDataSource localDataSource;

  NewsRepositoryImpl({
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
  Future<Either<Failure, List<News>>> getNews(String page) async {
    try {
      final news = await apiDataSource.getNews(page);

      return Right(news);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<News>>> loadNews(String page) async {
    try {
      final news = await apiDataSource.loadNews(page);

      return Right(news);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<News>>> refreshNews() async {
    try {
      final news = await apiDataSource.refreshNews();

      return Right(news);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NewsContent>> getNewContent(
      String id, int? userid) async {
    try {
      final news = await apiDataSource.getNewContent(id, userid);

      return Right(news);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, News>> getNewsBySlug(String slug) async {
    try {
      final news = await apiDataSource.getNewsBySlug(slug);

      return Right(news);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
