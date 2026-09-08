import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../core/error/failure.dart';

class SendVerificationEmail extends UseCase<bool, SendVerificationEmailParams> {
  final CustomerRepository repository;

  SendVerificationEmail(this.repository);

  Future<Either<Failure, bool>> call(SendVerificationEmailParams params) async {
    return await repository.sendVerificationEmail(params.id);
  }
}

class SendVerificationEmailParams extends Equatable {
  final String id;
  SendVerificationEmailParams({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
