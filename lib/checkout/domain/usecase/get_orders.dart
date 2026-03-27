import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/checkout/domain/repository/checkout_repository.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';

import '../../../core/error/failure.dart';
import '../entities/order.dart';

class GetOrders extends UseCase<List<OrderDetails>, GetOrdersParams> {
  final CheckoutRepository repository;

  GetOrders(this.repository);

  Future<Either<Failure, List<OrderDetails>>> call(
      GetOrdersParams params) async {
    return await repository.getOrders(params.userID);
  }
}

class GetOrdersParams extends Equatable {
  final int userID;
  GetOrdersParams({
    required this.userID,
  });

  @override
  List<Object> get props => [userID];
}
