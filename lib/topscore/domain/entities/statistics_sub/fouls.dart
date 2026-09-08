import 'dart:convert';

import 'package:equatable/equatable.dart';

class Fouls extends Equatable {
  final int? commited;
  final int? drawn;

  Fouls({
    this.commited,
    this.drawn,
  });
  @override
  List<Object?> get props => [
        commited,
        drawn,
      ];

  Map<String, dynamic> toMap() {
    return {
      'commited': commited,
      'drawn': drawn,
    };
  }

  factory Fouls.fromMap(Map<String, dynamic> map) {
    return Fouls(
      commited: map['commited']?.toInt(),
      drawn: map['drawn']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Fouls.fromJson(String source) => Fouls.fromMap(json.decode(source));
}
