import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class UpdateFinishedBet
    extends UseCase<List<List<Bet>>, UpdateFinishedBetParams> {
  final FootballMatchRepository repository;

  UpdateFinishedBet(this.repository);

  Future<Either<Failure, List<List<Bet>>>> call(
      UpdateFinishedBetParams params) async {
    return await repository.updateFinishedBet(
        params.id, params.bet, params.betLog);
  }
}

class UpdateFinishedBetParams extends Equatable {
  final String id;
  final List<Bet> bet;
  final List<Bet> betLog;
  UpdateFinishedBetParams(
      {required this.id, required this.bet, required this.betLog});

  @override
  List<Object> get props => [id, bet, betLog];
}
