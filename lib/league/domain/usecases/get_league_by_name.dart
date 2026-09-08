import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

class GetLeagueByName extends UseCase<League, GetLeagueByNameParams> {
  final LeagueRepository repository;

  GetLeagueByName(this.repository);

  Future<Either<Failure, League>> call(GetLeagueByNameParams params) async {
    return await repository.getLeagueByName(params.name);
  }
}

class GetLeagueByNameParams extends Equatable {
  final String name;

  GetLeagueByNameParams({
    required this.name,
  });

  @override
  List<Object> get props => [name];
}
