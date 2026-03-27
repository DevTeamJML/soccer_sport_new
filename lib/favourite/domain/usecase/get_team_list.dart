import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/favourite/domain/entities/league_team.dart';
import 'package:soccer_sport/favourite/domain/repository/favourite_team_repository.dart';

import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

import '../../../footballMatch/domain/entities/team.dart';

class GetTeamList extends UseCase<Map<String, List<Team>>, NoParams> {
  final FavouriteTeamRepository repository;

  GetTeamList(this.repository);

  Future<Either<Failure, Map<String, List<Team>>>> call(NoParams params) async {
    return await repository.getTeamList();
  }
}
