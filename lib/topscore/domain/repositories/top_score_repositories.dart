import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/topscore/domain/entities/top_score.dart';

abstract class TopScoreRepository {
  // Future<Either<Failure, List<LeagueDetails>>> getAllLeague();
  Future<Either<Failure, List<TopScore>>> getTopScoreByLeague(
      String id, String season);
}
