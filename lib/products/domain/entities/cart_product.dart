import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';

class CartProduct extends Equatable {
  final int productId;
  final int quantity;
  final String? name;
  final String? total;
  final int? price;
  final String? image;
  final int? variationsID;
  final Coupon? coupon;
  CartProduct({
    required this.productId,
    required this.quantity,
    this.name,
    this.total,
    this.price,
    this.image,
    this.variationsID,
    this.coupon,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.CartProduct, @required this.publishproductId, this.tags});

  @override
  List<Object?> get props =>
      [productId, quantity, name, total, price, image, coupon];

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
      if (name != null && name != '') 'name': name,
      if (total != null && total != '') 'total': total,
      if (price != null && price != '') 'price': price,
      if (image != null && image != '')
        'image': {
          'src': image,
        },
      if (variationsID != null && variationsID != '')
        'variation_id': variationsID,
      if (coupon != null) 'coupon_lines': coupon!.toMap()
    };
  }

  factory CartProduct.fromMap(Map<String, dynamic> map) {
    return CartProduct(
      productId: map['product_id'] ?? 0,
      quantity: map['quantity'],
      name: map['name'] ?? null,
      total: map['total'] ?? null,
      price: map['price'] ?? null,
      image: map['image'] != null
          ? (map['image'] as Map<String, dynamic>)['src']
          : null,
      variationsID: map['variation_id'] != null ? map['variation_id'] : null,
      coupon: map['coupon_lines'] != null
          ? Coupon.fromMap(map['coupon_lines'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartProduct.fromJson(String source) =>
      CartProduct.fromMap(json.decode(source));
}
