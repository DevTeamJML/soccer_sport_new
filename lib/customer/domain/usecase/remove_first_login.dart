// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import 'package:soccer_sport/core/usecase/usecase.dart';
// import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

// import '../../../core/error/failure.dart';

// class RemoveFirstLogin extends UseCase<bool, NoParams> {
//   final CustomerRepository repository;

//   RemoveFirstLogin(this.repository);

//   Future<Either<Failure, bool>> call(NoParams params) async {
//     return await repository.removeFirstLogin();
//   }
// }

// // class RemoveFirstLoginParams extends Equatable {
// //   final String token;
// //   RemoveFirstLoginParams({
// //     required this.token,
// //   });

// //   @override
// //   List<Object> get props => [token];
// // }
