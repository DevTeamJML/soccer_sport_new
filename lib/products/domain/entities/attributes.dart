import 'dart:convert';

import 'package:equatable/equatable.dart';

class Attributes extends Equatable {
  final String name;
  final List<String> options;
  Attributes({
    required this.name,
    required this.options,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.Attributes, @required this.publishname, this.tags});

  @override
  List<Object?> get props => [name, options];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'options': options,
    };
  }

  factory Attributes.fromMap(Map<String, dynamic> map) {
    return Attributes(
      name: map['name'] ?? '',
      options: map['options'] != null
          ? (map['options'] as List<dynamic>).map((e) => e as String).toList()
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Attributes.fromJson(String source) =>
      Attributes.fromMap(json.decode(source));
}
