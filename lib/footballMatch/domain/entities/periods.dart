import 'package:equatable/equatable.dart';

class Periods extends Equatable {
  int? first;
  int? second;
  Periods({this.first, this.second});

  @override
  List<Object?> get props => [
        first,
        second,
      ];
}
