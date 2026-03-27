import 'package:equatable/equatable.dart';

class Status extends Equatable {
  int? elapsedTime;
  String? long;
  String? short;
  Status({this.elapsedTime, this.short, this.long});

  @override
  List<Object?> get props => [
        elapsedTime,
        long,
        short,
      ];
}
