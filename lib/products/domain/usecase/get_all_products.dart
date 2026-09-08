import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/products/domain/repository/product_repository.dart';

import '../../../core/error/failure.dart';
import '../entities/product.dart';

class GetAllProducts extends UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getAllProducts();
  }
}
