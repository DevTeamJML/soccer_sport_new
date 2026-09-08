import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/repositories/standing_repositories.dart';

import '../entities/video_details.dart';
import '../repositories/video_details_repository.dart';

class GetRecentFeed extends UseCase<List<VideoDetails>, NoParams> {
  final VideoDetailsRepository repository;

  GetRecentFeed(this.repository);

  Future<Either<Failure, List<VideoDetails>>> call(NoParams params) async {
    return await repository.getRecentFeed();
  }
}
