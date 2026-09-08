import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/favourite/domain/entities/league_team.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

import '../../../footballMatch/domain/entities/team.dart';
import '../repository/favourite_team_repository.dart';

class PersistTeamList extends UseCase<bool, PersistTeamListParams> {
  final FavouriteTeamRepository repository;

  PersistTeamList(this.repository);

  Future<Either<Failure, bool>> call(PersistTeamListParams params) async {
    return await repository.persistTeamList(params.team);
  }
}

class PersistTeamListParams extends Equatable {
  final Map<String, List<dynamic>> team;

  PersistTeamListParams({
    required this.team,
  });

  @override
  List<Object> get props => [team];
}
