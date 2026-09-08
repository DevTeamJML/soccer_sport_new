import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../core/error/failure.dart';

class GetUserBalance extends UseCase<int, GetUserBalanceParams> {
  final CustomerRepository repository;

  GetUserBalance(this.repository);

  Future<Either<Failure, int>> call(GetUserBalanceParams params) async {
    return await repository.getUserBalance(params.userID);
  }
}

class GetUserBalanceParams extends Equatable {
  final int userID;
  GetUserBalanceParams({
    required this.userID,
  });

  @override
  List<Object> get props => [userID];
}
