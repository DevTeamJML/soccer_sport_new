import 'package:dartz/dartz.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/usecases/wordpress_login.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';

import '../entities/ssc_dialog.dart';
import '../entities/ssc_fab.dart';

abstract class BannerRepository {
  Future<Either<Failure, List<BannerHtml>>> getBanner(String api, id);
  Future<Either<Failure, String>> getUpdateDate();
  Future<Either<Failure, bool>> persistUpdateDate(String date);
  Future<Either<Failure, List<SscFab>>> getSscFab();
  Future<Either<Failure, List<SscDialog>>> getSscDialog();
}
