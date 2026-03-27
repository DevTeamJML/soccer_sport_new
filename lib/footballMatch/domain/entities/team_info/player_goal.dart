import 'package:equatable/equatable.dart';

import 'package:soccer_sport/league/domain/entities/league.dart';

import '../goal.dart';

class PlayerGoal extends Equatable {
  int total;
  int conceded;
  int  assists;
  int saves;

  PlayerGoal({
   required  this.total,
   required this.conceded,
   required  this.assists,
   required this.saves,
  });

  @override
  List<Object?> get props => [total, conceded, assists, saves];
  factory PlayerGoal.fromJson(Map<String, dynamic> json) {
    return PlayerGoal(
      total : json["total"] != null ? json["total"] : 0,
      conceded: json["conceded"] != null ? json["conceded"] : 0,
      assists: json["assists"] != null ? json["assists"]  : 0,
      saves : json['saves'] != null ? json["saves"]: 0, 
      
      );
  }
}
