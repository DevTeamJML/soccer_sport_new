import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_lineups.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_stats_info.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/predict.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetMatchPredict extends UseCase<Predict, GetMatchPredictParams> {
  final FootballMatchRepository repository;

  GetMatchPredict(this.repository);

  Future<Either<Failure, Predict>> call(GetMatchPredictParams params) async {
    return await repository.getMatchPredict(params.id);
  }
}

class GetMatchPredictParams extends Equatable {
  final String id;

  GetMatchPredictParams({required this.id});

  @override
  List<Object> get props => [id];
}
