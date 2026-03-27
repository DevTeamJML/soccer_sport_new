import 'package:dartz/dartz.dart';
import 'package:soccer_sport/checkout/domain/entities/order.dart';
import 'package:soccer_sport/products/domain/entities/cart_product.dart';

import '../../../core/error/failure.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, bool>> createOrder(OrderDetails order);
  Future<Either<Failure, List<OrderDetails>>> getOrders(int userID);
  Future<Either<Failure, bool>> checkLimitCheckout(List<CartProduct> order);
}
