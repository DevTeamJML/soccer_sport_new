import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

class CheckLocalLeagues extends UseCase<bool, CheckLocalLeaguesParams> {
  final LeagueRepository repository;

  CheckLocalLeagues(this.repository);

  Future<Either<Failure, bool>> call(CheckLocalLeaguesParams params) async {
    return await repository.checkLocalLeagues(params.leagues);
  }
}

class CheckLocalLeaguesParams extends Equatable {
  final List<LeagueDetails> leagues;

  CheckLocalLeaguesParams({
    required this.leagues,
  });

  @override
  List<Object> get props => [leagues];
}
