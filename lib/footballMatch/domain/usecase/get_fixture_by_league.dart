import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetFixtureByLeague
    extends UseCase<List<FootballMatch>, GetFixtureByLeagueParams> {
  final FootballMatchRepository repository;

  GetFixtureByLeague(this.repository);

  Future<Either<Failure, List<FootballMatch>>> call(
      GetFixtureByLeagueParams params) async {
    return await repository.getFixturesByLeague(params.id, params.season);
  }
}

class GetFixtureByLeagueParams extends Equatable {
  final String id;
  final String season;

  GetFixtureByLeagueParams({
    required this.id,
    required this.season,
  });

  @override
  List<Object> get props => [id, season];
}
