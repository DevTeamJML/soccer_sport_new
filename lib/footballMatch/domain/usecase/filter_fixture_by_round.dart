import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetFixtureByRound
    extends UseCase<List<FootballMatch>, GetFixtureByRoundParams> {
  final FootballMatchRepository repository;

  GetFixtureByRound(this.repository);

  Future<Either<Failure, List<FootballMatch>>> call(
      GetFixtureByRoundParams params) async {
    return await repository.getFixtureByRound(
        params.round, params.id, params.season);
  }
}

class GetFixtureByRoundParams extends Equatable {
  final String round;
  final String id;
  final String season;
  GetFixtureByRoundParams({
    required this.round,
    required this.id,
    required this.season,
  });

  @override
  List<Object> get props => [round, id, season];
}
