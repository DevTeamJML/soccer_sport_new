import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/products/domain/repository/product_repository.dart';

import '../../../core/error/failure.dart';
import '../entities/product.dart';

class GetProducts extends UseCase<List<Product>, GetProductsParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    return await repository.getProducts(
      params.page,
      params.perPage,
    );
  }
}

class GetProductsParams extends Equatable {
  final int? page;
  final int? perPage;
  GetProductsParams({
    required this.page,
    required this.perPage,
  });

  @override
  List<Object?> get props => [page, perPage];
}
