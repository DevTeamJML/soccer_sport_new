import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/repositories/standing_repositories.dart';

class GetStandingByTeam
    extends UseCase<List<LeagueStandings>, GetStandingByTeamParams> {
  final StandingRepository repository;

  GetStandingByTeam(this.repository);

  Future<Either<Failure, List<LeagueStandings>>> call(
      GetStandingByTeamParams params) async {
    return await repository.getStandingByTeam(params.id, params.season);
  }
}

class GetStandingByTeamParams extends Equatable {
  final String id;
  final int season;
  GetStandingByTeamParams({
    required this.id,
    required this.season,
  });

  @override
  List<Object> get props => [id, season];
}
