import 'dart:convert';

import 'package:equatable/equatable.dart';


class Reference extends Equatable {
  final String ref_id;
  final bool success;

  Reference({
    required this.ref_id,
    required this.success,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.Order, @required this.publishid, this.tags});

  @override
  List<Object?> get props => [
        ref_id,
        success,
      ];

  Map<String, dynamic> toMap() {
    return {
      'customer_id': ref_id,
      'set_paid': success,
    };
  }

  factory Reference.fromMap(Map<String, dynamic> map) {
    return Reference(
      ref_id: map['reference'] ?? '',
      success: map['value'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reference.fromJson(String source) =>
      Reference.fromMap(json.decode(source));
}
