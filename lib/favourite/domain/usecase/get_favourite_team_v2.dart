import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/favourite/domain/repository/favourite_team_repository.dart';

import '../../../footballMatch/domain/entities/team.dart';

class GetFavouriteTeamV2 extends UseCase<List<Team>, NoParams> {
  final FavouriteTeamRepository repository;

  GetFavouriteTeamV2(this.repository);

  Future<Either<Failure, List<Team>>> call(NoParams params) async {
    return await repository.getFavouriteTeamV2();
  }
}
