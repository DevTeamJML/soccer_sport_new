import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

import '../entities/league_details.dart';

class GetTeamSeason extends UseCase<List<LeagueDetails>, GetTeamSeasonParams> {
  final LeagueRepository repository;

  GetTeamSeason(this.repository);

  Future<Either<Failure, List<LeagueDetails>>> call(
      GetTeamSeasonParams params) async {
    return await repository.getTeamSeason(params.id);
  }
}

class GetTeamSeasonParams extends Equatable {
  final String id;

  GetTeamSeasonParams({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
