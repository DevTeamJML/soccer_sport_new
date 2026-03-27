import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:soccer_sport/products/domain/entities/cart_product.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';

import '../../../customer/domain/entities/billing.dart';

class OrderDetails extends Equatable {
  final int customerID;
  final String paymentMethod;
  final bool setPaid;
  final String transactionID;
  final List<CartProduct> lineItems;
  final int? orderID;
  final String? orderNumber;
  final String? status;
  final DateTime? orderDate;
  final DateTime? orderComplete;
  final Billing shipping;
  final List<Coupon>? coupon;

  OrderDetails({
    required this.customerID,
    required this.paymentMethod,
    required this.setPaid,
    required this.transactionID,
    required this.lineItems,
    this.orderID,
    this.orderNumber,
    this.status,
    this.orderDate,
    this.orderComplete,
    required this.shipping,
    this.coupon,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.Order, @required this.publishid, this.tags});

  @override
  List<Object?> get props => [
        customerID,
        paymentMethod,
        setPaid,
        transactionID,
        lineItems,
        orderID,
        orderNumber,
        status,
        orderDate,
        shipping,
        orderComplete,
        coupon,
      ];

  Map<String, dynamic> toMap() {
    return {
      'customer_id': customerID,
      'payment_method': paymentMethod,
      'set_paid': setPaid,
      'transaction_id': transactionID,
      'line_items': lineItems.map((e) => e.toMap()).toList(),
      if (orderID != null) 'id': orderID,
      if (orderNumber != null) 'order_key': orderNumber,
      if (status != null) 'status': status,
      if (orderDate != null) 'date_created': orderDate,
      'billing': shipping.toMap(),
      if (orderComplete != null) 'date_completed': orderComplete,
      if (coupon != null) "coupon_lines": coupon!.map((e) => e.toMap()).toList()
    };
  }

  factory OrderDetails.fromMap(Map<String, dynamic> map) {
    return OrderDetails(
      customerID: map['customer_id'] ?? '',
      paymentMethod: map['payment_method'] ?? '',
      setPaid: map['set_paid'] ?? false,
      transactionID: map['transaction_id'] ?? '',
      lineItems: map['line_items'] != null
          ? (map['line_items'] as List<dynamic>)
              .map((e) => CartProduct.fromMap(e))
              .toList()
          : [],
      orderID: map['id'] ?? 0,
      orderNumber: map['order_key'] ?? '',
      status: map['status'] ?? '',
      orderDate: map['date_created'] != null
          ? DateTime.parse(map['date_created'])
          : null,
      shipping: Billing.fromMap(map['billing']),
      orderComplete: map['date_completed'] != null
          ? DateTime.parse(map['date_completed'])
          : null,
      coupon: map['coupon_lines'] != null
          ? (map['coupon_lines'] as List<dynamic>)
              .map((e) => Coupon.fromMap(e))
              .toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetails.fromJson(String source) =>
      OrderDetails.fromMap(json.decode(source));
}
