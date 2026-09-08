import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/products/domain/entities/cart_item.dart';
import 'package:soccer_sport/products/domain/repository/product_repository.dart';

import '../../../core/error/failure.dart';

class GetProductVariations
    extends UseCase<List<CartItem>, GetProductVariationsParams> {
  final ProductRepository repository;

  GetProductVariations(this.repository);

  Future<Either<Failure, List<CartItem>>> call(
      GetProductVariationsParams params) async {
    return await repository.getProductVariations(
      params.id,
    );
  }
}

class GetProductVariationsParams extends Equatable {
  final int id;
  GetProductVariationsParams({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
