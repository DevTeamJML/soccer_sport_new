import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetFixturesCurrentRound
    extends UseCase<String, GetFixturesCurrentRoundParams> {
  final FootballMatchRepository repository;

  GetFixturesCurrentRound(this.repository);

  Future<Either<Failure, String>> call(
      GetFixturesCurrentRoundParams params) async {
    return await repository.getFixturesCurrentRound(params.id, params.season);
  }
}

class GetFixturesCurrentRoundParams extends Equatable {
  final String id;
  final String season;

  GetFixturesCurrentRoundParams({
    required this.id,
    required this.season,
  });

  @override
  List<Object> get props => [id, season];
}
