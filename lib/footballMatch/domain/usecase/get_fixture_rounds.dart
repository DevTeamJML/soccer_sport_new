import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetFixtureRounds extends UseCase<List<String>, GetFixtureRoundsParams> {
  final FootballMatchRepository repository;

  GetFixtureRounds(this.repository);

  Future<Either<Failure, List<String>>> call(
      GetFixtureRoundsParams params) async {
    return await repository.getFixtureRounds(params.id, params.season);
  }
}

class GetFixtureRoundsParams extends Equatable {
  final String id;
  final String season;

  GetFixtureRoundsParams({
    required this.id,
    required this.season,
  });

  @override
  List<Object> get props => [id, season];
}
