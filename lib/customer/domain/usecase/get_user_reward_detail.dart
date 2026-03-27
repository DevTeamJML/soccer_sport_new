import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/entities/customer_reward_detail.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/usecase.dart';

class GetUserRewardDetail
    extends UseCase<CustomerRewardDetail, GetUserRewardDetailParams> {
  final CustomerRepository repository;

  GetUserRewardDetail(this.repository);

  Future<Either<Failure, CustomerRewardDetail>> call(
      GetUserRewardDetailParams params) async {
    return await repository.getUserRewardDetail(params.id);
  }
}

class GetUserRewardDetailParams extends Equatable {
  final String id;
  GetUserRewardDetailParams({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
