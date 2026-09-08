import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_info.dart';
import 'package:soccer_sport/lucky_draw/domain/repository/lucky_draw_repo.dart';

class RetrieveLuckyDraw
    extends UseCase<LuckyDrawInfo, RetrieveLuckyDrawParams> {
  final LuckyDrawRepository repository;

  RetrieveLuckyDraw(this.repository);

  Future<Either<Failure, LuckyDrawInfo>> call(
      RetrieveLuckyDrawParams params) async {
    return await repository.retrieveLuckyDraw(params.id);
  }
}

class RetrieveLuckyDrawParams extends Equatable {
  final int id;

  RetrieveLuckyDrawParams({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
