import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/customer/domain/entities/verified_detail.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../core/error/failure.dart';

class CheckVerified extends UseCase<VerifiedDetail, CheckVerifiedParams> {
  final CustomerRepository repository;

  CheckVerified(this.repository);

  Future<Either<Failure, VerifiedDetail>> call(
      CheckVerifiedParams params) async {
    return await repository.checkVerified(params.id);
  }
}

class CheckVerifiedParams extends Equatable {
  final String id;
  CheckVerifiedParams({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
