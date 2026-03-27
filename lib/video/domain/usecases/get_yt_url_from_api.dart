import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/repositories/standing_repositories.dart';

import '../entities/video_details.dart';
import '../repositories/video_details_repository.dart';

class GetYtUrlFromApi extends UseCase<String, GetYtUrlFromApiParams> {
  final VideoDetailsRepository repository;

  GetYtUrlFromApi(this.repository);

  Future<Either<Failure, String>> call(GetYtUrlFromApiParams params) async {
    return await repository.getYtUrlFromApi(params.api);
  }
}

class GetYtUrlFromApiParams extends Equatable {
  final String api;
  GetYtUrlFromApiParams({
    required this.api,
  });

  @override
  List<Object> get props => [api];
}
