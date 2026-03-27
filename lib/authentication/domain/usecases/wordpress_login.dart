import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/repositories/auth_repository.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class WordpressLogin extends UseCase<WordpressAuth?, WordpressLoginParams> {
  final AuthRepository repository;

  WordpressLogin(this.repository);

  Future<Either<Failure, WordpressAuth?>> call(
      WordpressLoginParams params) async {
    return await repository.wordpressLogin(
      params.username,
      params.password,
    );
  }
}

class WordpressLoginParams extends Equatable {
  final String username;
  final String password;
  WordpressLoginParams({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}
