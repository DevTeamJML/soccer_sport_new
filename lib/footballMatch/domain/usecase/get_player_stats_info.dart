import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';

import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

import '../entities/team_info/player_stats_info_v2.dart';

class GetPlayerStatInfo
    extends UseCase<List<PlayerStatsInfoV2>, GetPlayerStatInfoParams> {
  final FootballMatchRepository repository;

  GetPlayerStatInfo(this.repository);

  Future<Either<Failure, List<PlayerStatsInfoV2>>> call(
      GetPlayerStatInfoParams params) async {
    return await repository.getPlayerStatsInfo(params.id, params.season);
  }
}

class GetPlayerStatInfoParams extends Equatable {
  final String id;
  final String season;

  GetPlayerStatInfoParams({required this.id, required this.season});

  @override
  List<Object> get props => [id, season];
}
