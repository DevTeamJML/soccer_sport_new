import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/checkout/domain/repository/checkout_repository.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/products/domain/entities/cart_product.dart';

import '../../../core/error/failure.dart';
import '../entities/order.dart';

class CheckLimitCheckout extends UseCase<bool, CheckLimitCheckoutParams> {
  final CheckoutRepository repository;

  CheckLimitCheckout(this.repository);

  Future<Either<Failure, bool>> call(CheckLimitCheckoutParams params) async {
    return await repository.checkLimitCheckout(params.orders);
  }
}

class CheckLimitCheckoutParams extends Equatable {
  final List<CartProduct> orders;
  CheckLimitCheckoutParams({
    required this.orders,
  });

  @override
  List<Object> get props => [orders];
}
