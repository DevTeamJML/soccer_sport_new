import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetIncomingLiveMatch extends UseCase<List<FootballMatch>?, NoParams> {
  final FootballMatchRepository repository;

  GetIncomingLiveMatch(this.repository);

  Future<Either<Failure, List<FootballMatch>?>> call(NoParams params) async {
    return await repository.getIncomingLiveMatch();
  }
}
