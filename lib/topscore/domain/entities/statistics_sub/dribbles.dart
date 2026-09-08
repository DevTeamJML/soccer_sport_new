import 'dart:convert';

import 'package:equatable/equatable.dart';

class Dribbles extends Equatable {
  final int? attempt;
  final int? past;
  final int? success;

  Dribbles({this.attempt, this.past, this.success});
  @override
  List<Object?> get props => [
        attempt,
        past,
        success,
      ];

  Map<String, dynamic> toMap() {
    return {
      'attempt': attempt,
      'past': past,
      'success': success,
    };
  }

  factory Dribbles.fromMap(Map<String, dynamic> map) {
    return Dribbles(
      attempt: map['attempt']?.toInt(),
      past: map['past']?.toInt(),
      success: map['success']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Dribbles.fromJson(String source) =>
      Dribbles.fromMap(json.decode(source));
}
