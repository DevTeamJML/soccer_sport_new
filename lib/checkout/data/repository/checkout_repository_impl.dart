import 'package:dartz/dartz.dart';
import 'package:soccer_sport/checkout/data/datasources/checkout_api.dart';
import 'package:soccer_sport/checkout/domain/entities/order.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/products/domain/entities/cart_product.dart';

import '../../../core/error/exception.dart';
import '../../domain/repository/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final OrderApiDataSource apiDataSource;
  // final ProductLocalDataSource localDataSource;
  // final ArticleLocalDataSource localDataSource;

  CheckoutRepositoryImpl({
    required this.apiDataSource,
    // required this.localDataSource,
  });

  @override
  Future<Either<Failure, bool>> createOrder(OrderDetails order) async {
    try {
      final success = await apiDataSource.createOrder(order);

      return Right(success);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<OrderDetails>>> getOrders(int userID) async {
    try {
      final success = await apiDataSource.getOrders(userID);

      return Right(success);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkLimitCheckout(
      List<CartProduct> order) async {
    try {
      final success = await apiDataSource.checkLimitCheckout(order);

      return Right(success);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
