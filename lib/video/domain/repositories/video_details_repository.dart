import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/topscore/domain/entities/top_score.dart';
import 'package:soccer_sport/video/domain/entities/video_details.dart';

abstract class VideoDetailsRepository {
  // Future<Either<Failure, List<LeagueDetails>>> getAllLeague();
  Future<Either<Failure, List<VideoDetails>>> getRecentFeed();
  Future<Either<Failure, String>> getYtUrlFromApi(String api);
    Future<Either<Failure, bool>> checkSscLive();

}
