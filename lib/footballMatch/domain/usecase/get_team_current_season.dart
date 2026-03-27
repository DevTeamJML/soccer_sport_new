import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetFixturesByTeam
    extends UseCase<List<FootballMatch>, GetFixturesByTeamParams> {
  final FootballMatchRepository repository;

  GetFixturesByTeam(this.repository);

  Future<Either<Failure, List<FootballMatch>>> call(
      GetFixturesByTeamParams params) async {
    return await repository.getFixturesByTeam(
      params.id,
      params.season,
    );
  }
}

class GetFixturesByTeamParams extends Equatable {
  final String id;
  final String season;

  GetFixturesByTeamParams({
    required this.id,
    required this.season,
  });

  @override
  List<Object> get props => [id, season];
}
