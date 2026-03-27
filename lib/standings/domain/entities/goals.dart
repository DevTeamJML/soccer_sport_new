import 'package:equatable/equatable.dart';

class Goals extends Equatable {
  final int? goalsFor;
  final int? against;

  Goals({this.goalsFor, this.against});
  @override
  List<Object?> get props => [
        goalsFor,
        against,
      ];
}
