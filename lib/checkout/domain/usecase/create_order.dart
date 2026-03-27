import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/checkout/domain/repository/checkout_repository.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';

import '../../../core/error/failure.dart';
import '../entities/order.dart';

class CreateOrder extends UseCase<bool, CreateOrderParams> {
  final CheckoutRepository repository;

  CreateOrder(this.repository);

  Future<Either<Failure, bool>> call(CreateOrderParams params) async {
    return await repository.createOrder(params.order);
  }
}

class CreateOrderParams extends Equatable {
  final OrderDetails order;
  CreateOrderParams({
    required this.order,
  });

  @override
  List<Object> get props => [order];
}
