import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_info.dart';
import 'package:soccer_sport/lucky_draw/domain/repository/lucky_draw_repo.dart';

class LuckyDraw extends UseCase<LuckyDrawInfo, LuckyDrawParams> {
  final LuckyDrawRepository repository;

  LuckyDraw(this.repository);

  Future<Either<Failure, LuckyDrawInfo>> call(LuckyDrawParams params) async {
    return await repository.luckyDraw(params.lucky_draw);
  }
}

class LuckyDrawParams extends Equatable {
  final LuckyDrawInfo lucky_draw;

  LuckyDrawParams({
    required this.lucky_draw,
  });

  @override
  List<Object> get props => [lucky_draw];
}
