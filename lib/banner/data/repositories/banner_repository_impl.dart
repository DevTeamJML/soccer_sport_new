import 'package:dartz/dartz.dart';
import 'package:soccer_sport/authentication/data/datasources/wordpress_auth_api.dart';
import 'package:soccer_sport/authentication/data/datasources/wordpress_auth_local.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/repositories/auth_repository.dart';
import 'package:soccer_sport/banner/data/datasources/banner_local.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/banner/domain/entities/ssc_dialog.dart';
import 'package:soccer_sport/banner/domain/entities/ssc_fab.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/footballMatch/data/datasources/football_match_api.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

import '../../domain/repositories/banner_repository.dart';
import '../datasources/banner_api.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerApiDataSource apiDataSource;
  final BannerLocalDataSource localDataSource;

  BannerRepositoryImpl({
    required this.apiDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<BannerHtml>>> getBanner(String api, id) async {
    try {
      final persit = await apiDataSource.getBanner(api, id);

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getUpdateDate() async {
    try {
      final persit = await localDataSource.getUpdateDate();

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> persistUpdateDate(String date) async {
    try {
      final persit = await localDataSource.persistUpdateDate(date);

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<SscDialog>>> getSscDialog() async {
    try {
      final persit = await apiDataSource.getSscDialog();

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<SscFab>>> getSscFab() async {
    try {
      final persit = await apiDataSource.getSscFab();

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
