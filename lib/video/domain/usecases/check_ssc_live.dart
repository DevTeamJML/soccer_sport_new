import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/repositories/standing_repositories.dart';

import '../entities/video_details.dart';
import '../repositories/video_details_repository.dart';

class CheckSscLive extends UseCase<bool, NoParams> {
  final VideoDetailsRepository repository;

  CheckSscLive(this.repository);

  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.checkSscLive();
  }
}
