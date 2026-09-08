import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

class PersistLocalLeagues extends UseCase<bool, PersistLocalLeaguesParams> {
  final LeagueRepository repository;

  PersistLocalLeagues(this.repository);

  Future<Either<Failure, bool>> call(PersistLocalLeaguesParams params) async {
    return await repository.persistLocalLeagues(params.leagues);
  }
}

class PersistLocalLeaguesParams extends Equatable {
  final List<LeagueDetails> leagues;

  PersistLocalLeaguesParams({
    required this.leagues,
  });

  @override
  List<Object> get props => [leagues];
}
