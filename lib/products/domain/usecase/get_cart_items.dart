import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/products/domain/entities/cart_item.dart';
import 'package:soccer_sport/products/domain/repository/product_repository.dart';

import '../../../core/error/failure.dart';

class GetCartItems extends UseCase<List<CartItem>, GetCartItemsParams> {
  final ProductRepository repository;

  GetCartItems(this.repository);

  Future<Either<Failure, List<CartItem>>> call(
      GetCartItemsParams params) async {
    return await repository.getCartItems(
      params.userId,
    );
  }
}

class GetCartItemsParams extends Equatable {
  final int userId;
  GetCartItemsParams({
    required this.userId,
  });

  @override
  List<Object> get props => [userId];
}
