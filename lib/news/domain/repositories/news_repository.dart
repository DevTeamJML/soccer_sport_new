import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/entities/news_content.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:wordpress_api/wordpress_api.dart';

abstract class NewsRepository {
  // Future<Either<Failure, List<LeagueDetails>>> getAllLeague();
  Future<Either<Failure, List<News>>> getNews(String page);
  Future<Either<Failure, List<News>>> loadNews(String page);
  Future<Either<Failure, List<News>>> refreshNews();
  Future<Either<Failure, NewsContent>> getNewContent(String id, int? userid);
  Future<Either<Failure, News>> getNewsBySlug(String slug);
}
