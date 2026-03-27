import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:wordpress_api/wordpress_api.dart';

abstract class NotificationRepository {
  // Future<Either<Failure, List<LeagueDetails>>> getAllLeague();
  Future<Either<Failure, bool?>> getNotification();
  Future<Either<Failure, bool>> persistNotification(bool notifcation);
  Future<Either<Failure, bool>> removeNotification();
}
