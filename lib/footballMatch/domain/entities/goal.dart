import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  int? home;
  int? away;
  Goal({this.home, this.away});

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [home, away];
}
