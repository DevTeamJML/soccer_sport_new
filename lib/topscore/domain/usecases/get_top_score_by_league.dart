import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/repositories/standing_repositories.dart';
import 'package:soccer_sport/topscore/domain/entities/top_score.dart';
import 'package:soccer_sport/topscore/domain/repositories/top_score_repositories.dart';

class GetTopScoreByLeague
    extends UseCase<List<TopScore>, GetTopScoreByLeagueParams> {
  final TopScoreRepository repository;

  GetTopScoreByLeague(this.repository);

  Future<Either<Failure, List<TopScore>>> call(
      GetTopScoreByLeagueParams params) async {
    return await repository.getTopScoreByLeague(params.id, params.season);
  }
}

class GetTopScoreByLeagueParams extends Equatable {
  final String id;
  final String season;
  GetTopScoreByLeagueParams({
    required this.id,
    required this.season,
  });

  @override
  List<Object> get props => [id, season];
}
