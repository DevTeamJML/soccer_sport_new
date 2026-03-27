import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_info.dart';
import 'package:soccer_sport/lucky_draw/domain/repository/lucky_draw_repo.dart';

class PersistCoupons extends UseCase<bool, PersistCouponsParams> {
  final LuckyDrawRepository repository;

  PersistCoupons(this.repository);

  Future<Either<Failure, bool>> call(PersistCouponsParams params) async {
    return await repository.persistCoupons(params.coupons);
  }
}

class PersistCouponsParams extends Equatable {
  final Map<String, dynamic> coupons;

  PersistCouponsParams({
    required this.coupons,
  });

  @override
  List<Object> get props => [coupons];
}
