import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';
import 'package:soccer_sport/products/domain/repository/product_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/cart.dart';
import '../entities/cart_item.dart';
import '../entities/product.dart';

class GenerateCoupon extends UseCase<List<Coupon>, GenerateCouponParams> {
  final ProductRepository repository;

  GenerateCoupon(this.repository);

  Future<Either<Failure, List<Coupon>>> call(
      GenerateCouponParams params) async {
    return await repository.generateCoupon(params.coupon);
  }
}

class GenerateCouponParams extends Equatable {
  final List<Coupon> coupon;

  GenerateCouponParams({
    required this.coupon,
  });

  @override
  List<Object> get props => [
        coupon,
      ];
}
