import 'dart:convert';

import 'package:equatable/equatable.dart';

class Games extends Equatable {
  final int? appearences;
  final bool? captain;
  final int? lineups;
  final int? number;
  final String? position;
  final String? rating;

  Games(
      {this.appearences,
      this.captain,
      this.lineups,
      this.number,
      this.position,
      this.rating});
  @override
  List<Object?> get props =>
      [appearences, captain, lineups, number, position, rating];

  Map<String, dynamic> toMap() {
    return {
      'appearences': appearences,
      'captain': captain,
      'lineups': lineups,
      'number': number,
      'position': position,
      'rating': rating,
    };
  }

  factory Games.fromMap(Map<String, dynamic> map) {
    return Games(
      appearences: map['appearences']?.toInt(),
      captain: map['captain'],
      lineups: map['lineups']?.toInt(),
      number: map['number']?.toInt(),
      position: map['position'],
      rating: map['rating'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Games.fromJson(String source) => Games.fromMap(json.decode(source));
}
