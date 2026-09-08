import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/entities/customer_reward_detail.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/usecase.dart';

class GetDailyReward extends UseCase<int, GetDailyRewardParams> {
  final CustomerRepository repository;

  GetDailyReward(this.repository);

  Future<Either<Failure, int>> call(GetDailyRewardParams params) async {
    return await repository.getDailyReward(params.customerRewardDetail);
  }
}

class GetDailyRewardParams extends Equatable {
  final CustomerRewardDetail customerRewardDetail;
  GetDailyRewardParams({
    required this.customerRewardDetail,
  });

  @override
  List<Object> get props => [customerRewardDetail];
}
