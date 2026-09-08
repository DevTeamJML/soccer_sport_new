import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:soccer_sport/products/domain/entities/cart_product.dart';

class Cart extends Equatable {
  final int userId;
  final List<CartProduct> products;

  Cart({
    required this.userId,
    required this.products,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.Cart, @required this.publishuserId, this.tags});

  @override
  List<Object?> get props => [userId, products];

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'products': products.map((e) => e.toMap()).toList()
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      userId: map['user_id'] ?? 0,
      products: (map['products'] as List<dynamic>)
          .map((e) => CartProduct.fromMap(e))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));
}
