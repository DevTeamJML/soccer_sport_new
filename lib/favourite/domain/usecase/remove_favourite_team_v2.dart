import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/favourite/domain/repository/favourite_team_repository.dart';

import '../../../footballMatch/domain/entities/team.dart';

class RemoveFavouriteTeamV2 extends UseCase<bool, RemoveFavouriteTeamV2Params> {
  final FavouriteTeamRepository repository;

  RemoveFavouriteTeamV2(this.repository);

  Future<Either<Failure, bool>> call(RemoveFavouriteTeamV2Params params) async {
    return await repository.removeFavouriteTeamV2(
      params.team,
    );
  }
}

class RemoveFavouriteTeamV2Params extends Equatable {
  final Team team;

  RemoveFavouriteTeamV2Params({
    required this.team,
  });

  @override
  List<Object> get props => [
        team,
      ];
}
