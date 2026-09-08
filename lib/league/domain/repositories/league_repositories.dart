import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';

abstract class LeagueRepository {
  Future<Either<Failure, List<LeagueDetails>>> getAllLeague();
  Future<Either<Failure, League>> getLeagueByName(String name);
  Future<Either<Failure, List<LeagueDetails>>> getLocalLeagues();
  Future<Either<Failure, bool>> checkLocalLeagues(List<LeagueDetails> list);
  Future<Either<Failure, bool>> persistLocalLeagues(List<LeagueDetails> list);
  Future<Either<Failure, String>> getUpdateDate();
  Future<Either<Failure, bool>> persistUpdateDate(String date);
  Future<Either<Failure, List<LeagueDetails>>> getTeamSeason(String id);
}
