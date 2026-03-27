import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/repositories/auth_repository.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/banner/domain/repositories/banner_repository.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';

class PersistDailyUpdateDate
    extends UseCase<bool, PersistDailyUpdateDateParams> {
  final BannerRepository repository;

  PersistDailyUpdateDate(this.repository);

  Future<Either<Failure, bool>> call(
      PersistDailyUpdateDateParams params) async {
    return await repository.persistUpdateDate(params.date);
  }
}

class PersistDailyUpdateDateParams extends Equatable {
  final String date;
  PersistDailyUpdateDateParams({
    required this.date,
  });

  @override
  List<Object> get props => [date];
}
