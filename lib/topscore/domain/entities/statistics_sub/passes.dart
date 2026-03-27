import 'dart:convert';

import 'package:equatable/equatable.dart';

class Passes extends Equatable {
  final int? accuracy;
  final int? key;
  final int? total;

  Passes({this.accuracy, this.key, this.total});
  @override
  List<Object?> get props => [
        accuracy,
        key,
        total,
      ];

  Map<String, dynamic> toMap() {
    return {
      'accuracy': accuracy,
      'key': key,
      'total': total,
    };
  }

  factory Passes.fromMap(Map<String, dynamic> map) {
    return Passes(
      accuracy: map['accuracy']?.toInt(),
      key: map['key']?.toInt(),
      total: map['total']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Passes.fromJson(String source) => Passes.fromMap(json.decode(source));
}
