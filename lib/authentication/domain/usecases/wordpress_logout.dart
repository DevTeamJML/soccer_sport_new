import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/repositories/auth_repository.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';

class WordpressLogout extends UseCase<bool, NoParams> {
  final AuthRepository repository;

  WordpressLogout(this.repository);

  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.wordpressLogout();
  }
}
