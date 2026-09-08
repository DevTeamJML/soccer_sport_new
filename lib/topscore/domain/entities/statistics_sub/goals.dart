import 'dart:convert';

import 'package:equatable/equatable.dart';

class Goals extends Equatable {
  final int? assists;
  final int? conceded;
  final int? saves;
  final int? total;

  Goals({this.assists, this.conceded, this.saves, this.total});
  @override
  List<Object?> get props => [
        assists,
        conceded,
        saves,
        total,
      ];

  Map<String, dynamic> toMap() {
    return {
      'assists': assists,
      'conceded': conceded,
      'saves': saves,
      'total': total,
    };
  }

  factory Goals.fromMap(Map<String, dynamic> map) {
    return Goals(
      assists: map['assists']?.toInt(),
      conceded: map['conceded']?.toInt(),
      saves: map['saves']?.toInt(),
      total: map['total']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Goals.fromJson(String source) => Goals.fromMap(json.decode(source));
}
