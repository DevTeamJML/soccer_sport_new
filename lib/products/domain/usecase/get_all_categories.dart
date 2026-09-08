import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';

import '../../../core/error/failure.dart';
import '../entities/category.dart';
import '../repository/product_repository.dart';

class GetAllCategories extends UseCase<List<Category>, NoParams> {
  final ProductRepository repository;

  GetAllCategories(this.repository);

  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getAllCategories();
  }
}
