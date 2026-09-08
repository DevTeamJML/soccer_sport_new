import 'package:equatable/equatable.dart';

import 'package:soccer_sport/league/domain/entities/league.dart';

import '../goal.dart';

class PlayerCard extends Equatable {
  int yellow;
  int yellowRed;
  int red;

  PlayerCard({
    required this.yellow,
    required this.yellowRed,
    required this.red,
  });

  @override
  List<Object?> get props => [yellow, yellowRed, red];
  factory PlayerCard.fromJson(Map<String, dynamic> json) {
    return PlayerCard(
      yellow: json["yellow"] != null ? json["yellow"] : 0,
      yellowRed: json["yellowred"] != null ? json["yellowred"] : 0,
      red: json["red"] != null ? json["red"] : 0,
    );
  }
}
