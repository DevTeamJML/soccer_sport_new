import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetAllMatch extends UseCase<List<FootballMatch>, NoParams> {
  final FootballMatchRepository repository;

  GetAllMatch(this.repository);

  Future<Either<Failure, List<FootballMatch>>> call(NoParams params) async {
    return await repository.getAllMatch();
  }
}
