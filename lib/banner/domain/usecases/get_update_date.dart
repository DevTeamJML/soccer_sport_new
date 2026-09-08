import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/repositories/auth_repository.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/banner/domain/repositories/banner_repository.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';

class GetDailyUpdateDate extends UseCase<String, NoParams> {
  final BannerRepository repository;

  GetDailyUpdateDate(this.repository);

  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.getUpdateDate();
  }
}
