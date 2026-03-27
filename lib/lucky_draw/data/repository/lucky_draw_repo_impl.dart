import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/league/data/datasources/league_api.dart';
import 'package:soccer_sport/league/data/datasources/league_local.dart';
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';
import 'package:soccer_sport/lucky_draw/data/datasources/lucky_draw_api.dart';
import 'package:soccer_sport/lucky_draw/data/datasources/lucky_draw_local.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_info.dart';
import 'package:soccer_sport/lucky_draw/domain/repository/lucky_draw_repo.dart';

class LuckyDrawRepositoryImpl implements LuckyDrawRepository {
  final LuckyDrawApiDateSource apiDataSource;
  final LuckyDrawLocalSource localDataSource;
  // final ArticleLocalDataSource localDataSource;

  LuckyDrawRepositoryImpl({
    required this.apiDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, LuckyDrawInfo>> luckyDraw(
      LuckyDrawInfo luckyDraw) async {
    try {
      final lucky_draw = await apiDataSource.luckyDraw(luckyDraw);

      return Right(lucky_draw);
    } on NotEnugCoin {
      return Left(NotEnugCoinFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, LuckyDrawInfo>> retrieveLuckyDraw(int id) async {
    try {
      final lucky_draw = await apiDataSource.retrieveLuckyDraw(id);

      return Right(lucky_draw);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> persistCoupons(
      Map<String, dynamic> coupons) async {
    try {
      final lucky_draw = await localDataSource.updateCoupons(coupons);

      return Right(lucky_draw);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> retrieveCoupons() async {
    try {
      final lucky_draw = await localDataSource.getCoupons();

      return Right(lucky_draw);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
