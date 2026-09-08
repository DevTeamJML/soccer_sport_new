import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/products/domain/repository/product_repository.dart';


import '../../../core/error/failure.dart';
import '../entities/product.dart';

class GetCategoryProducts
    extends UseCase<List<Product>, GetCategoryProductsParams> {
  final ProductRepository repository;

  GetCategoryProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(
      GetCategoryProductsParams params) async {
    return await repository.getCategoryProducts(params.id);
  }
}

class GetCategoryProductsParams extends Equatable {
  final int id;
  GetCategoryProductsParams({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
