import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/repositories/auth_repository.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class PersistAuth extends UseCase<bool, PersistAuthParams> {
  final AuthRepository repository;

  PersistAuth(this.repository);

  Future<Either<Failure, bool>> call(PersistAuthParams params) async {
    return await repository.persistAuth(
      params.auth,
    );
  }
}

class PersistAuthParams extends Equatable {
  final WordpressAuth auth;
  PersistAuthParams({
    required this.auth,
  });

  @override
  List<Object> get props => [
        auth,
      ];
}
