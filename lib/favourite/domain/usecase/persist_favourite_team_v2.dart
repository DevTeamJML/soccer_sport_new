import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';

import '../../../footballMatch/domain/entities/team.dart';
import '../repository/favourite_team_repository.dart';

class PersistFavouriteTeamV2
    extends UseCase<bool, PersistFavouriteTeamV2Params> {
  final FavouriteTeamRepository repository;

  PersistFavouriteTeamV2(this.repository);

  Future<Either<Failure, bool>> call(
      PersistFavouriteTeamV2Params params) async {
    return await repository.persistFavouriteTeamV2(
      params.team,
    );
  }
}

class PersistFavouriteTeamV2Params extends Equatable {
  final Team team;

  PersistFavouriteTeamV2Params({
    required this.team,
  });

  @override
  List<Object> get props => [team, id];
}
