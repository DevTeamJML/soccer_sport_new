import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/banner/domain/entities/ssc_fab.dart';
import 'package:soccer_sport/banner/domain/repositories/banner_repository.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';

import '../entities/ssc_dialog.dart';

class GetSscDialog extends UseCase<List<SscDialog>, NoParams> {
  final BannerRepository repository;

  GetSscDialog(this.repository);

  Future<Either<Failure, List<SscDialog>>> call(NoParams params) async {
    return await repository.getSscDialog();
  }
}
