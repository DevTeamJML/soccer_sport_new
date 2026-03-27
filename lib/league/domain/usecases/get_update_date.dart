import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

class GetUpdateDate extends UseCase<String, NoParams> {
  final LeagueRepository repository;

  GetUpdateDate(this.repository);

  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.getUpdateDate();
  }
}
