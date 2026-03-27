import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class DeleteAccount extends UseCase<bool, NoParams> {
  final AuthRepository repository;

  DeleteAccount(this.repository);

  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.deleteAccount();
  }
}
