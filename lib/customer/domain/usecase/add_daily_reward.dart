import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/entities/customer_reward_detail.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/usecase.dart';

class AddDailyReward extends UseCase<bool, AddDailyRewardParams> {
  final CustomerRepository repository;

  AddDailyReward(this.repository);

  Future<Either<Failure, bool>> call(AddDailyRewardParams params) async {
    return await repository.addDailyReward(params.points);
  }
}

class AddDailyRewardParams extends Equatable {
  final String points;
  AddDailyRewardParams({
    required this.points,
  });

  @override
  List<Object> get props => [points];
}
