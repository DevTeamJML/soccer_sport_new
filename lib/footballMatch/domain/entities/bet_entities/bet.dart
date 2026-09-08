import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/team.dart';
// import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/team.dart';

class Bet extends Equatable {
  int id;
  int lId;
  Team home;
  Team away;
  String status;
  String predict;
  int value;
  DateTime date;

  Bet({
    required this.id,
    required this.lId,
    required this.home,
    required this.away,
    required this.status,
    required this.predict,
    required this.value,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        lId,
        home,
        away,
        status,
        predict,
        value,
        date,
      ];

  factory Bet.fromJson(Map<String, dynamic> json) {
    return Bet(
        id: json['id'],
        lId: json['lId'],
        home: Team.fromJson(json['home']),
        away: Team.fromJson(json['away']),
        status: json['status'],
        predict: json['predict'],
        value: json['value'],
        date: DateTime.fromMillisecondsSinceEpoch(json['date']));
  }

  factory Bet.update(Bet bet, bool home, bool away, String status) {
    return Bet(
      id: bet.id,
      lId: bet.lId,
      home: Team(name: bet.home.name, logoUrl: bet.home.logoUrl, winner: home),
      away: Team(name: bet.away.name, logoUrl: bet.away.logoUrl, winner: away),
      status: status,
      predict: bet.predict,
      value: bet.value,
      date: bet.date,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lId': lId,
      'home': home.toJson(),
      'away': away.toJson(),
      'status': status,
      'predict': predict,
      'value': value,
      'date': date.millisecondsSinceEpoch
    };
  }
}
