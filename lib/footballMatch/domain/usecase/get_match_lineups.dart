import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_lineups.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_stats_info.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetMatchLineups
    extends UseCase<List<MatchLineups>, GetMatchLineupsParams> {
  final FootballMatchRepository repository;

  GetMatchLineups(this.repository);

  Future<Either<Failure, List<MatchLineups>>> call(
      GetMatchLineupsParams params) async {
    return await repository.getMatchLineups(params.id);
  }
}

class GetMatchLineupsParams extends Equatable {
  final String id;

  GetMatchLineupsParams({required this.id});

  @override
  List<Object> get props => [id];
}
