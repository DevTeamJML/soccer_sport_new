import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../core/error/failure.dart';

class GetCustomerDetails extends UseCase<Customer, GetCustomerDetailsParams> {
  final CustomerRepository repository;

  GetCustomerDetails(this.repository);

  Future<Either<Failure, Customer>> call(
      GetCustomerDetailsParams params) async {
    return await repository.getCustomerDetails(params.userID);
  }
}

class GetCustomerDetailsParams extends Equatable {
  final int userID;
  GetCustomerDetailsParams({
    required this.userID,
  });

  @override
  List<Object> get props => [userID];
}
