import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/goal.dart';

class Score extends Equatable {
  Goal? halftime;
  Goal? fulltime;
  Goal? extratime;
  Goal? penalty;

  Score({this.halftime, this.fulltime, this.extratime, this.penalty});

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [halftime, fulltime, extratime, penalty];
}
