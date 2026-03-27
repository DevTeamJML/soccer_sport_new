import 'package:dartz/dartz.dart';
import 'package:soccer_sport/authentication/data/datasources/wordpress_auth_api.dart';
import 'package:soccer_sport/authentication/data/datasources/wordpress_auth_local.dart';
import 'package:soccer_sport/authentication/domain/entities/user.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/repositories/auth_repository.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/footballMatch/data/datasources/football_match_api.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

class AuthRepositoryImpl implements AuthRepository {
  final WordpressAuthApiDataSource apiDataSource;
  final WordpressAuthLocalDataSource localDataSource;
  // final ArticleLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.apiDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, WordpressAuth?>> wordpressLogin(
      String username, String password) async {
    try {
      final auth = await apiDataSource.wordpressLogin(username, password);

      return Right(auth);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> wordpressLogout() async {
    try {
      final auth = await localDataSource.wordpressLogout();

      return Right(auth);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuth() async {
    try {
      final auth = await localDataSource.checkAuth();

      return Right(auth);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, WordpressAuth>> getAuth() async {
    try {
      final auth = await localDataSource.getAuth();

      return Right(auth);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> persistAuth(WordpressAuth auth) async {
    try {
      final persit = await localDataSource.persistAuth(auth);

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> validateAuth() async {
    try {
      final persit = await apiDataSource.validateAuth();

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAccount() async {
    try {
      final persit = await apiDataSource.deleteAccount();

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<bool?>>> checkFirstTimeLogin() async {
    try {
      final persit = await localDataSource.checkFirstTimeLogin();

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeFirstTimeInstall() async {
    try {
      final persit = await localDataSource.removeFirstTimeInstall();

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> setFirstTimeInstall() async {
    try {
      final persit = await localDataSource.setFirstTimeInstall();

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> registerUser(
      String username, email, password) async {
    try {
      final persit =
          await apiDataSource.registerUser(username, email, password);

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool?>> checkMember() async {
    try {
      final persit = await localDataSource.checkMember();

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> setBetGuide() async {
    try {
      final persit = await localDataSource.setBetGuide();

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeBetGuide() async {
    try {
      final persit = await localDataSource.removeBetGuide();

      return Right(persit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
