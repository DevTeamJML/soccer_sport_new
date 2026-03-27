import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';

import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_stats_info.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetMatchStatsInfo
    extends UseCase<List<MatchStatsInfo>, GetMatchStatsInfoParams> {
  final FootballMatchRepository repository;

  GetMatchStatsInfo(this.repository);

  Future<Either<Failure, List<MatchStatsInfo>>> call(
      GetMatchStatsInfoParams params) async {
    return await repository.getMatchStatsInfo(params.id);
  }
}

class GetMatchStatsInfoParams extends Equatable {
  final String id;

  GetMatchStatsInfoParams({required this.id});

  @override
  List<Object> get props => [id];
}
