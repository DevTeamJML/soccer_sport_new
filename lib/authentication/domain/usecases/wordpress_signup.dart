// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import 'package:soccer_sport/core/error/failure.dart';
// import 'package:soccer_sport/core/usecase/usecase.dart';
// import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
// import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';

// class WordpressSignup
//     extends UseCase<List<FootballMatch>, WordpressSignupParams> {
//   final FootballMatchRepository repository;

//   WordpressSignup(this.repository);

//   Future<Either<Failure, List<FootballMatch>>> call(
//       WordpressSignupParams params) async {
//     return await repository.WordpressSignup(
//       params.username,
//       params.password,
//     );
//   }
// }

// class WordpressSignupParams extends Equatable {
//   final String username;
//   final String password;
//   WordpressSignupParams({
//     required this.username,
//     required this.password,
//   });

//   @override
//   List<Object> get props => [username, password];
// }
