import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetBetLog extends UseCase<List<List<Bet>>, GetBetLogParams> {
  final FootballMatchRepository repository;

  GetBetLog(this.repository);

  Future<Either<Failure, List<List<Bet>>>> call(GetBetLogParams params) async {
    return await repository.getBetLog(params.id);
  }
}

class GetBetLogParams extends Equatable {
  final String id;

  GetBetLogParams({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
