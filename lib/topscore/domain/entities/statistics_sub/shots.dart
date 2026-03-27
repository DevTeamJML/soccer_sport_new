import 'dart:convert';

import 'package:equatable/equatable.dart';

class Shots extends Equatable {
  final int? on;
  final int? total;

  Shots({
    this.on,
    this.total,
  });
  @override
  List<Object?> get props => [
        on,
        total,
      ];

  Map<String, dynamic> toMap() {
    return {
      'on': on,
      'total': total,
    };
  }

  factory Shots.fromMap(Map<String, dynamic> map) {
    return Shots(
      on: map['on']?.toInt(),
      total: map['total']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Shots.fromJson(String source) => Shots.fromMap(json.decode(source));
}
