import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/repositories/standing_repositories.dart';

class GetStandingByLeague
    extends UseCase<LeagueStandings?, GetStandingByLeagueParams> {
  final StandingRepository repository;

  GetStandingByLeague(this.repository);

  Future<Either<Failure, LeagueStandings?>> call(
      GetStandingByLeagueParams params) async {
    return await repository.getStandingByLeague(params.id, params.season);
  }
}

class GetStandingByLeagueParams extends Equatable {
  final String id;
  final int season;
  GetStandingByLeagueParams({
    required this.id,
    required this.season,
  });

  @override
  List<Object> get props => [id, season];
}
