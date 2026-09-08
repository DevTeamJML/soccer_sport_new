import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/customer/domain/entities/cny_detail.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/entities/customer_reward_detail.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/usecase.dart';

class CnyGetDetail extends UseCase<CnyRewardDetail, CnyGetDetailParams> {
  final CustomerRepository repository;

  CnyGetDetail(this.repository);

  Future<Either<Failure, CnyRewardDetail>> call(
      CnyGetDetailParams params) async {
    return await repository.cnyGetDetail(params.id);
  }
}

class CnyGetDetailParams extends Equatable {
  final String id;
  CnyGetDetailParams({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
