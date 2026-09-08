import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_ranking/bet_ranking.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetBetRanking extends UseCase<List<BetRanking>, NoParams> {
  final FootballMatchRepository repository;

  GetBetRanking(this.repository);

  Future<Either<Failure, List<BetRanking>>> call(NoParams params) async {
    return await repository.getBetRanking();
  }
}
