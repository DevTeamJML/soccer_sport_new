import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class GetFixtureBetweenDates
    extends UseCase<List<FootballMatch>, GetFixtureBetweenDatesParams> {
  final FootballMatchRepository repository;

  GetFixtureBetweenDates(this.repository);

  Future<Either<Failure, List<FootballMatch>>> call(
      GetFixtureBetweenDatesParams params) async {
    return await repository.getFixtureBetweenDates(params.ids);
  }
}

class GetFixtureBetweenDatesParams extends Equatable {
  final List<String> ids;

  GetFixtureBetweenDatesParams({
    required this.ids,
  });

  @override
  List<Object> get props => [ids];
}
