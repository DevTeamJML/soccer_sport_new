import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/customer/domain/entities/cny_detail.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/entities/customer_reward_detail.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/usecase.dart';

class CnyAddReward extends UseCase<bool, CnyAddRewardParams> {
  final CustomerRepository repository;

  CnyAddReward(this.repository);

  Future<Either<Failure, bool>> call(CnyAddRewardParams params) async {
    return await repository.cnyAddReward(params.points);
  }
}

class CnyAddRewardParams extends Equatable {
  final CnyRewardDetail points;
  CnyAddRewardParams({
    required this.points,
  });

  @override
  List<Object> get props => [points];
}
