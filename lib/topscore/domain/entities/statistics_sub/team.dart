import 'dart:convert';

import 'package:equatable/equatable.dart';

class Team extends Equatable {
  final int? id;
  final String? logo;
  final String? name;

  Team({this.id, this.logo, this.name});
  @override
  List<Object?> get props => [
        id,
        logo,
        name,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logo': logo,
      'name': name,
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id']?.toInt(),
      logo: map['logo'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Team.fromJson(String source) => Team.fromMap(json.decode(source));
}
