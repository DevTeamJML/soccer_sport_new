import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

class GetLocalLeagues extends UseCase<List<LeagueDetails>, NoParams> {
  final LeagueRepository repository;

  GetLocalLeagues(this.repository);

  Future<Either<Failure, List<LeagueDetails>>> call(NoParams params) async {
    return await repository.getLocalLeagues();
  }
}
