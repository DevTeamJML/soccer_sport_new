import 'dart:convert';

import 'package:equatable/equatable.dart';

class CartAttributes extends Equatable {
  final String? size;
  final String? color;
  final String? option;

  CartAttributes({
    this.size,
    this.color,
    this.option,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.CartAttributes, @required this.publishsize, this.tags});

  @override
  List<Object?> get props => [size, color, option];

  Map<String, dynamic> toMap() {
    return {
      'size': size,
      'option': option,
      'color': color,
    };
  }

  factory CartAttributes.fromMap(Map<String, dynamic> map) {
    return CartAttributes(
      size: map['attribute_size'] != null ? map['attribute_size'] : null,
      color: map['attribute_color'] != null ? map['attribute_color'] : null,
      option: map['attribute_option'] != null ? map['attribute_option'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartAttributes.fromJson(String source) =>
      CartAttributes.fromMap(json.decode(source));
}
