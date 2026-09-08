import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

class PersistUpdateDate extends UseCase<bool, PersistUpdateDateParams> {
  final LeagueRepository repository;

  PersistUpdateDate(this.repository);

  Future<Either<Failure, bool>> call(PersistUpdateDateParams params) async {
    return await repository.persistUpdateDate(params.date);
  }
}

class PersistUpdateDateParams extends Equatable {
  final String date;

  PersistUpdateDateParams({
    required this.date,
  });

  @override
  List<Object> get props => [date];
}
