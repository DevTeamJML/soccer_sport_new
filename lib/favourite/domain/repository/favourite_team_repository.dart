import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/favourite/domain/entities/league_team.dart';

import '../../../footballMatch/domain/entities/team.dart';

abstract class FavouriteTeamRepository {
  Future<Either<Failure, Map<String, List<Team>>>> getFavouriteTeam();
  Future<Either<Failure, bool>> persistFavouriteTeam(Team team, String id);
  Future<Either<Failure, bool>> removeFavouriteTeam(Team team, String id);
  Future<Either<Failure, bool>> persistTeamList(
      Map<String, List<dynamic>> team);
  Future<Either<Failure, Map<String, List<Team>>>> getTeamList();
  Future<Either<Failure, bool>> getAllFavouriteTeam();
  Future<Either<Failure, List<Team>>> getFavouriteTeamV2();
  Future<Either<Failure, bool>> persistFavouriteTeamV2(
    Team team,
  );
  Future<Either<Failure, bool>> removeFavouriteTeamV2(
    Team team,
  );
}
