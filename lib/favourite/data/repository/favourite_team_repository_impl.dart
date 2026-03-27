import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/favourite/data/datasource/favourite_team_local.dart';
import 'package:soccer_sport/favourite/domain/entities/league_team.dart';
import 'package:soccer_sport/favourite/domain/repository/favourite_team_repository.dart';
import 'package:soccer_sport/footballMatch/data/model/team_model.dart';
import 'package:soccer_sport/league/data/datasources/league_api.dart';
import 'package:soccer_sport/league/data/datasources/league_local.dart';
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';

import '../../../footballMatch/domain/entities/team.dart';

class FavouriteTeamRepositoryImpl implements FavouriteTeamRepository {
  final FavouriteTeamLocalDataSource localDataSource;

  // final ArticleLocalDataSource localDataSource;

  FavouriteTeamRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Map<String, List<Team>>>> getFavouriteTeam() async {
    try {
      final teams = await localDataSource.getFavouriteTeam();

      return Right(teams);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> persistFavouriteTeam(
      Team team, String id) async {
    try {
      final teams = await localDataSource.persistFavouriteTeam(team, id);

      return Right(teams);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeFavouriteTeam(
      Team team, String id) async {
    try {
      final teams = await localDataSource.removeFavouriteTeam(team, id);

      return Right(teams);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> persistTeamList(
      Map<String, List<dynamic>> team) async {
    try {
      final teams = await localDataSource.persistTeamList(team);

      return Right(teams);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, List<Team>>>> getTeamList() async {
    try {
      final teams = await localDataSource.getTeamList();

      return Right(teams);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getAllFavouriteTeam() async {
    try {
      final teams = await localDataSource.getAllFavouriteTeam();

      return Right(teams);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Team>>> getFavouriteTeamV2() async {
    try {
      final teams = await localDataSource.getFavouriteTeamV2();

      return Right(teams);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> persistFavouriteTeamV2(Team team) async {
    try {
      final teams = await localDataSource.persistFavouriteTeamV2(team);

      return Right(teams);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeFavouriteTeamV2(Team team) async {
    try {
      final teams = await localDataSource.removeFavouriteTeamV2(team);

      return Right(teams);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
