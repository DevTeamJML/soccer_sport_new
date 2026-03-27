import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/shipping.dart';

class EditAddress extends UseCase<Customer, EditAddressParams> {
  final CustomerRepository repository;

  EditAddress(this.repository);

  Future<Either<Failure, Customer>> call(EditAddressParams params) async {
    return await repository.editAddress(params.shipping);
  }
}

class EditAddressParams extends Equatable {
  final Shipping shipping;
  EditAddressParams({
    required this.shipping,
  });

  @override
  List<Object> get props => [shipping];
}
