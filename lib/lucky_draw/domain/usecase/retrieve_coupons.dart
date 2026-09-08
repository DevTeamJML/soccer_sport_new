import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_info.dart';
import 'package:soccer_sport/lucky_draw/domain/repository/lucky_draw_repo.dart';

class RetrieveCoupons extends UseCase<Map<String, dynamic>, NoParams> {
  final LuckyDrawRepository repository;

  RetrieveCoupons(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    return await repository.retrieveCoupons();
  }
}
