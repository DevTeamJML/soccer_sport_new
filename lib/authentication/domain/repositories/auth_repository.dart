import 'package:dartz/dartz.dart';
import 'package:soccer_sport/authentication/domain/entities/user.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/usecases/check_first_time_login.dart';
import 'package:soccer_sport/authentication/domain/usecases/check_member.dart';
import 'package:soccer_sport/authentication/domain/usecases/wordpress_login.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';

abstract class AuthRepository {
  Future<Either<Failure, WordpressAuth?>> wordpressLogin(
      String username, String password);

  Future<Either<Failure, bool>> wordpressLogout();
  Future<Either<Failure, bool>> deleteAccount();
  Future<Either<Failure, WordpressAuth>> getAuth();

  Future<Either<Failure, bool>> checkAuth();
  Future<Either<Failure, bool>> persistAuth(WordpressAuth auth);
  Future<Either<Failure, bool>> validateAuth();
  Future<Either<Failure, List<bool?>>> checkFirstTimeLogin();
  Future<Either<Failure, bool?>> checkMember();

  Future<Either<Failure, bool>> removeFirstTimeInstall();
  Future<Either<Failure, bool>> removeBetGuide();

  Future<Either<Failure, bool>> setFirstTimeInstall();
  Future<Either<Failure, bool>> setBetGuide();

  Future<Either<Failure, User?>> registerUser(String username, email, password);
}
