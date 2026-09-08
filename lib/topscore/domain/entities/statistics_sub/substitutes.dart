import 'dart:convert';

import 'package:equatable/equatable.dart';

class Substitutes extends Equatable {
  final int? bench;
  //in
  final int? subIn;
  final int? out;

  Substitutes({this.bench, this.subIn, this.out});
  @override
  List<Object?> get props => [
        bench,
        subIn,
        out,
      ];

  Map<String, dynamic> toMap() {
    return {
      'bench': bench,
      'in': subIn,
      'out': out,
    };
  }

  factory Substitutes.fromMap(Map<String, dynamic> map) {
    return Substitutes(
      bench: map['bench']?.toInt(),
      subIn: map['in']?.toInt(),
      out: map['out']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Substitutes.fromJson(String source) =>
      Substitutes.fromMap(json.decode(source));
}
