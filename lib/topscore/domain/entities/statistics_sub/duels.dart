import 'dart:convert';

import 'package:equatable/equatable.dart';

class Duels extends Equatable {
  final int? total;
  final int? won;

  Duels({
    this.total,
    this.won,
  });
  @override
  List<Object?> get props => [
        total,
        won,
      ];

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'won': won,
    };
  }

  factory Duels.fromMap(Map<String, dynamic> map) {
    return Duels(
      total: map['total']?.toInt(),
      won: map['won']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Duels.fromJson(String source) => Duels.fromMap(json.decode(source));
}
