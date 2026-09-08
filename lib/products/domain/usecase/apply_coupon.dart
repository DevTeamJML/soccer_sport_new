import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';
import 'package:soccer_sport/products/domain/repository/product_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/cart.dart';
import '../entities/cart_item.dart';
import '../entities/product.dart';

class ApplyCoupon extends UseCase<Coupon, ApplyCouponParams> {
  final ProductRepository repository;

  ApplyCoupon(this.repository);

  Future<Either<Failure, Coupon>> call(ApplyCouponParams params) async {
    return await repository.applyCoupon(
      params.code,
    );
  }
}

class ApplyCouponParams extends Equatable {
  final String code;
  ApplyCouponParams({
    required this.code,
  });

  @override
  List<Object> get props => [code];
}
