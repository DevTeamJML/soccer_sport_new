import 'dart:convert';

import 'package:equatable/equatable.dart';

class Tackels extends Equatable {
  final int? blocks;
  final int? interceptions;
  final int? total;

  Tackels({this.blocks, this.interceptions, this.total});
  @override
  List<Object?> get props => [
        blocks,
        interceptions,
        total,
      ];

  Map<String, dynamic> toMap() {
    return {
      'blocks': blocks,
      'interceptions': interceptions,
      'total': total,
    };
  }

  factory Tackels.fromMap(Map<String, dynamic> map) {
    return Tackels(
      blocks: map['blocks']?.toInt(),
      interceptions: map['interceptions']?.toInt(),
      total: map['total']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Tackels.fromJson(String source) =>
      Tackels.fromMap(json.decode(source));
}
