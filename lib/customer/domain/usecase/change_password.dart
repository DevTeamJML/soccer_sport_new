// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';

// import 'package:ubuy/core/usecases/usecase.dart';
// import 'package:ubuy/customer/domain/entities/customer.dart';
// import 'package:ubuy/products/domain/repository/product_repository.dart';

// import '../../../core/error/failure.dart';
// import '../repository/customer_repository.dart';

// class ChangePassword extends UseCase<bool, ChangePasswordParams> {
//   final CustomerRepository repository;

//   ChangePassword(this.repository);

//   Future<Either<Failure, bool>> call(ChangePasswordParams params) async {
//     return await repository.changePassword(params.password);
//   }
// }

// class ChangePasswordParams extends Equatable {
//   final String password;
//   ChangePasswordParams({
//     required this.password,
//   });

//   @override
//   List<Object> get props => [password];
// }
