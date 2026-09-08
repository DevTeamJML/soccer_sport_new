import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/favourite/domain/repository/favourite_team_repository.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

import '../../../footballMatch/domain/entities/team.dart';

class RemoveFavouriteTeam extends UseCase<bool, RemoveFavouriteTeamParams> {
  final FavouriteTeamRepository repository;

  RemoveFavouriteTeam(this.repository);

  Future<Either<Failure, bool>> call(RemoveFavouriteTeamParams params) async {
    return await repository.removeFavouriteTeam(params.team, params.id);
  }
}

class RemoveFavouriteTeamParams extends Equatable {
  final Team team;
  final String id;

  RemoveFavouriteTeamParams({
    required this.team,
    required this.id,
  });

  @override
  List<Object> get props => [team, id];
}
