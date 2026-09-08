import 'dart:convert';

import 'package:equatable/equatable.dart';

class Penalty extends Equatable {
  final int? commited;
  final int? missed;
  final int? saved;
  final int? scored;
  final int? won;

  Penalty({this.commited, this.missed, this.saved, this.scored, this.won});
  @override
  List<Object?> get props => [
        commited,
        missed,
        saved,
        scored,
        won,
      ];

  Map<String, dynamic> toMap() {
    return {
      'commited': commited,
      'missed': missed,
      'saved': saved,
      'scored': scored,
      'won': won,
    };
  }

  factory Penalty.fromMap(Map<String, dynamic> map) {
    return Penalty(
      commited: map['commited']?.toInt(),
      missed: map['missed']?.toInt(),
      saved: map['saved']?.toInt(),
      scored: map['scored']?.toInt(),
      won: map['won']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Penalty.fromJson(String source) =>
      Penalty.fromMap(json.decode(source));
}
