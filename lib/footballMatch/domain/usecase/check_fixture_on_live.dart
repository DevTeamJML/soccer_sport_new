import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class CheckFixtureOnLive
    extends UseCase<FootballMatch?, CheckFixtureOnLiveParams> {
  final FootballMatchRepository repository;

  CheckFixtureOnLive(this.repository);

  Future<Either<Failure, FootballMatch?>> call(
      CheckFixtureOnLiveParams params) async {
    return await repository.checkFixtureOnLive(params.ongoingMatch);
  }
}

class CheckFixtureOnLiveParams extends Equatable {
  final FootballMatch ongoingMatch;

  CheckFixtureOnLiveParams({
    required this.ongoingMatch,
  });

  @override
  List<Object> get props => [ongoingMatch];
}
