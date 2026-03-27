// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';

// import 'package:ubuy/core/usecases/usecase.dart';
// import 'package:ubuy/customer/domain/repository/customer_repository.dart';
// import 'package:ubuy/products/domain/repository/product_repository.dart';

// import '../../../core/error/failure.dart';

// class ConvertDiamonds extends UseCase<bool, ConvertDiamondsParams> {
//   final CustomerRepository repository;

//   ConvertDiamonds(this.repository);

//   Future<Either<Failure, bool>> call(ConvertDiamondsParams params) async {
//     return await repository.convertDiamonds(params.diamonds);
//   }
// }

// class ConvertDiamondsParams extends Equatable {
//   final int diamonds;
//   ConvertDiamondsParams({
//     required this.diamonds,
//   });

//   @override
//   List<Object> get props => [diamonds];
// }
