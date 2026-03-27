import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetIncomingFixtureByLeague
    extends UseCase<List<FootballMatch>, GetIncomingFixtureByLeagueParams> {
  final FootballMatchRepository repository;

  GetIncomingFixtureByLeague(this.repository);

  Future<Either<Failure, List<FootballMatch>>> call(
      GetIncomingFixtureByLeagueParams params) async {
    return await repository.getIncomingFixturesByLeague(
        params.id, params.season);
  }
}

class GetIncomingFixtureByLeagueParams extends Equatable {
  final String id;
  final String season;
  GetIncomingFixtureByLeagueParams({
    required this.id,
    required this.season,
  });

  @override
  List<Object> get props => [id, season];
}
