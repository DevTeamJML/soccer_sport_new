import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/entities/customer_reward_detail.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../core/error/failure.dart';

class UpdatePersonalize
    extends UseCase<CustomerRewardDetail, UpdatePersonalizeParams> {
  final CustomerRepository repository;

  UpdatePersonalize(this.repository);

  Future<Either<Failure, CustomerRewardDetail>> call(
      UpdatePersonalizeParams params) async {
    return await repository.updatePersonalize(params.userID, params.leagues);
  }
}

class UpdatePersonalizeParams extends Equatable {
  final String userID;
  final List<int> leagues;
  UpdatePersonalizeParams({
    required this.userID,
    required this.leagues,
  });

  @override
  List<Object> get props => [userID, leagues];
}
