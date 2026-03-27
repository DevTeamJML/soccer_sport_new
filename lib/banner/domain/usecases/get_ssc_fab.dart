import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/banner/domain/entities/ssc_fab.dart';
import 'package:soccer_sport/banner/domain/repositories/banner_repository.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';

class GetSscFab extends UseCase<List<SscFab>, NoParams> {
  final BannerRepository repository;

  GetSscFab(this.repository);

  Future<Either<Failure, List<SscFab>>> call(NoParams params) async {
    return await repository.getSscFab();
  }
}
