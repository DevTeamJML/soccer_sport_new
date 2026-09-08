import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:soccer_sport/products/domain/entities/cart_attributes.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';

class CartItem extends Equatable {
  final int productId;
  final String? productName;
  final String? productRegularPrice;
  final String? productSalePrice;
  final String? thumbnail;
  final int? quantity;
  final int? lineSubtotal;
  final int? lineTotal;
  final int? variation_id;
  final String? price;
  final CartAttributes? cartAttributes;
  final int? id;
  final Coupon? coupon;

  CartItem({
    required this.productId,
    this.productName,
    this.productRegularPrice,
    this.productSalePrice,
    this.thumbnail,
    this.lineSubtotal,
    this.lineTotal,
    this.quantity,
    this.variation_id,
    this.cartAttributes,
    this.price,
    this.id,
    this.coupon,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.CartItem, @required this.publishproductId, this.tags});

  @override
  List<Object?> get props => [
        productId,
        quantity,
        productName,
        productRegularPrice,
        productSalePrice,
        thumbnail,
        lineSubtotal,
        lineTotal,
        variation_id,
        cartAttributes,
        price,
        id,
        coupon,
      ];

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'qty': quantity,
      'product_name': productName,
      'product_regular_price': productRegularPrice,
      'product_sale_price': productSalePrice,
      'thumbnail': thumbnail,
      'line_subtotal': lineSubtotal,
      'line_total': lineTotal,
      if (variation_id != null) 'variation_id': variation_id,
      if (cartAttributes != null) 'attributes': cartAttributes,
      'price': price,
      'id': id,
      if (coupon != null) 'coupon_lines': coupon!.toMap(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['product_id'] ?? 0,
      quantity: map['qty'] != null ? map['qty'] : 0,
      productName: map['product_name'] != null ? map['product_name'] : "",
      productRegularPrice: map['product_regular_price'] != ""
          ? map['product_regular_price']
          : null,
      productSalePrice:
          map['product_sale_price'] != null ? map['product_sale_price'] : null,
      thumbnail: map['thumbnail'] != null ? map['thumbnail'] : null,
      lineSubtotal: map['line_subtotal'] != null ? map['line_subtotal'] : 0,
      lineTotal: map['line_total'] != null ? map['line_total'] : 0,
      variation_id: map['variation_id'] != null ? map['variation_id'] : null,
      cartAttributes: map['attributes'] == null
          ? null
          : map['attributes'] is List<dynamic>
              ? null
              : CartAttributes.fromMap(map['attributes']),
      price: map['price'] != null ? map['price'] : null,
      id: map['id'] != null ? map['id'] : null,
      coupon: map['coupon_lines'] != null ? map['coupon_lines'] : null,
    );
  }

  factory CartItem.changeQuantity(CartItem item, int quantity) {
    return CartItem(
      productId: item.productId,
      quantity: quantity,
      productName: item.productName,
      productRegularPrice: item.productRegularPrice,
      productSalePrice: item.productSalePrice,
      thumbnail: item.thumbnail,
      lineSubtotal: item.lineSubtotal,
      lineTotal: item.lineTotal,
      variation_id: item.variation_id,
      price: item.price,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source));
}
