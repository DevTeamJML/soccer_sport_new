import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class BetWonUpdate extends UseCase<bool, BetWonUpdateParams> {
  final FootballMatchRepository repository;

  BetWonUpdate(this.repository);

  Future<Either<Failure, bool>> call(BetWonUpdateParams params) async {
    return await repository.betWonUpdate(params.id, params.value, params.data);
  }
}

class BetWonUpdateParams extends Equatable {
  final String id;
  final int value;
  final List<String> data;

  BetWonUpdateParams({
    required this.id,
    required this.value,
    required this.data,
  });

  @override
  List<Object> get props => [id, value, data];
}
