import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/repositories/auth_repository.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/banner/domain/repositories/banner_repository.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';

class GetBanner extends UseCase<List<BannerHtml>, GetBannerParams> {
  final BannerRepository repository;

  GetBanner(this.repository);

  Future<Either<Failure, List<BannerHtml>>> call(GetBannerParams params) async {
    return await repository.getBanner(params.link, params.id);
  }
}

class GetBannerParams extends Equatable {
  final String link;
  final String id;
  GetBannerParams({
    required this.link,
    required this.id,
  });

  @override
  List<Object> get props => [link, id];
}
