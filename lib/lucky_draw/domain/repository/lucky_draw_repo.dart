import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_info.dart';
import 'package:soccer_sport/lucky_draw/domain/usecase/retrieve_coupons.dart';

abstract class LuckyDrawRepository {
  Future<Either<Failure, LuckyDrawInfo>> luckyDraw(LuckyDrawInfo luckyDraw);
  Future<Either<Failure, LuckyDrawInfo>> retrieveLuckyDraw(int id);
  Future<Either<Failure, Map<String, dynamic>>> retrieveCoupons();
  Future<Either<Failure, bool>> persistCoupons(Map<String, dynamic> coupons);
}
