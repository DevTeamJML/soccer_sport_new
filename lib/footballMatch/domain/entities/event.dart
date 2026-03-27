import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/data/model/team_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event%20subentities/player.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event%20subentities/time.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team.dart';

class Event extends Equatable {
  final Time time;
  final Team? team;
  final Player? player;
  final Player? assist;
  final String? type;
  final String? detail;
  Event({
    required this.time,
    this.team,
    this.type,
    this.assist,
    this.detail,
    this.player,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishteam, this.tags});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      time: Time.fromJson(json['time']),
      team: json['team'] != null ? TeamModel.fromJson(json['team']) : null,
      player: json['player'] != null ? Player.fromJson(json['player']) : null,
      assist: json['assist'] != null ? Player.fromJson(json['assist']) : null,
      type: json['type'] != null ? json['type'] : null,
      detail: json['detail'] != null ? json['detail'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toJson(),
      if (team != null) 'team': TeamModel.fromEntity(team!).toJson(),
      if (player != null) 'player': player!.toJson(),
      if (assist != null) 'assist': assist!.toJson(),
      'type': type,
      'detail': detail,
    };
  }

  @override
  List<Object?> get props => [time, team, player, assist, detail, type];
}
