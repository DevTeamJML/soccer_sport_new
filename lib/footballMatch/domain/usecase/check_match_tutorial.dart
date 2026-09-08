import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class CheckMatchTutorial extends UseCase<bool, NoParams> {
  final FootballMatchRepository repository;

  CheckMatchTutorial(this.repository);

  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.checkMatchTutorial();
  }
}
