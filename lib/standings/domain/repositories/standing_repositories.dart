import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';

abstract class StandingRepository {
  // Future<Either<Failure, List<LeagueDetails>>> getAllLeague();
  Future<Either<Failure, LeagueStandings?>> getStandingByLeague(
      String id, int season);
  Future<Either<Failure, List<LeagueStandings>>> getStandingByTeam(
      String id, int season);
}
