import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/favourite/domain/repository/favourite_team_repository.dart';

import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

import '../../../footballMatch/domain/entities/team.dart';

class GetAllFavouriteTeam extends UseCase<bool, NoParams> {
  final FavouriteTeamRepository repository;

  GetAllFavouriteTeam(this.repository);

  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.getAllFavouriteTeam();
  }
}
