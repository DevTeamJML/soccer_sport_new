import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/products/domain/repository/product_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/cart.dart';
import '../entities/cart_item.dart';
import '../entities/product.dart';

class AddToCart extends UseCase<List<CartItem>, AddToCartParams> {
  final ProductRepository repository;

  AddToCart(this.repository);

  Future<Either<Failure, List<CartItem>>> call(AddToCartParams params) async {
    return await repository.addToCart(
      params.cart,
    );
  }
}

class AddToCartParams extends Equatable {
  final Cart cart;
  AddToCartParams({
    required this.cart,
  });

  @override
  List<Object> get props => [cart];
}
