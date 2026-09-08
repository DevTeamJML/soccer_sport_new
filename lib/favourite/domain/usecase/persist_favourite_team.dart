import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

import '../../../footballMatch/domain/entities/team.dart';
import '../repository/favourite_team_repository.dart';

class PersistFavouriteTeam extends UseCase<bool, PersistFavouriteTeamParams> {
  final FavouriteTeamRepository repository;

  PersistFavouriteTeam(this.repository);

  Future<Either<Failure, bool>> call(PersistFavouriteTeamParams params) async {
    return await repository.persistFavouriteTeam(params.team, params.id);
  }
}

class PersistFavouriteTeamParams extends Equatable {
  final Team team;
  final String id;

  PersistFavouriteTeamParams({
    required this.team,
    required this.id,
  });

  @override
  List<Object> get props => [team, id];
}
