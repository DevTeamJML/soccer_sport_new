import 'dart:convert';

import 'package:equatable/equatable.dart';

class Cards extends Equatable {
  final int? red;
  final int? yellow;
  final int? yellowred;

  Cards({this.red, this.yellow, this.yellowred});
  @override
  List<Object?> get props => [
        red,
        yellow,
        yellowred,
      ];

  Map<String, dynamic> toMap() {
    return {
      'red': red,
      'yellow': yellow,
      'yellowred': yellowred,
    };
  }

  factory Cards.fromMap(Map<String, dynamic> map) {
    return Cards(
      red: map['red']?.toInt(),
      yellow: map['yellow']?.toInt(),
      yellowred: map['yellowred']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cards.fromJson(String source) => Cards.fromMap(json.decode(source));
}
