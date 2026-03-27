import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/authentication/domain/entities/user.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/repositories/auth_repository.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class RegisterUser extends UseCase<User?, RegisterUserParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<Either<Failure, User?>> call(RegisterUserParams params) async {
    return await repository.registerUser(
      params.username,
      params.email,
      params.password,
    );
  }
}

class RegisterUserParams extends Equatable {
  final String username;
  final String email;
  final String password;
  RegisterUserParams({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [username, email, password];
}
