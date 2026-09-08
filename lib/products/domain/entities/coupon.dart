import 'dart:convert';

import 'package:equatable/equatable.dart';

class Coupon extends Equatable {
  final int? id;
  final String code;
  final String? amount;
  final String? type;
  final bool? individual_use;
  final List<String>? email_restrictions;
  final List<int>? product_ids;
  final List<int>? used_by;
  final int? usage_limit_per_user;
  final int? limit_usage_to_x_items;
  final int? usage_limit;

  Coupon({
    required this.code,
    this.id,
    this.amount,
    this.type,
    this.individual_use,
    this.email_restrictions,
    this.product_ids,
    this.used_by,
    this.usage_limit_per_user,
    this.limit_usage_to_x_items,
    this.usage_limit,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.Coupon, @required this.publishcode, this.tags});

  @override
  List<Object?> get props => [code];

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (type != null) 'discount_type': type,
      if (individual_use != null) 'individual_use': individual_use,
      if (email_restrictions != null) 'email_restrictions': email_restrictions,
      if (product_ids != null) 'product_ids': product_ids,
      if (used_by != null) 'used_by': used_by,
      if (usage_limit_per_user != null)
        'usage_limit_per_user': usage_limit_per_user,
      if (limit_usage_to_x_items != null)
        'limit_usage_to_x_items': limit_usage_to_x_items,
      if (usage_limit != null) 'usage_limit': usage_limit,
    };
  }

  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      code: map['code'] ?? '',
      id: map['id'] != null ? map['id'] : null,
      amount: map['amount'] != null ? map['amount'] : null,
      type: map['discount_type'] != null ? map['discount_type'] : null,
      individual_use:
          map['individual_use'] != null ? map['individual_use'] : null,
      email_restrictions: map['email_restrictions'] != null
          ? (map['email_restrictions'] as List<dynamic>)
              .map((e) => e.toString())
              .toList()
          : null,
      product_ids: map['product_ids'] != null
          ? (map['product_ids'] as List<dynamic>)
              .map((e) => e is int ? e : int.parse(e))
              .toList()
          : null,
      used_by: map['used_by'] != null
          ? (map['used_by'] as List<dynamic>)
              .map((e) => e is int ? e : int.parse(e))
              .toList()
          : null,
      usage_limit_per_user: map['usage_limit_per_user'] != null
          ? map['usage_limit_per_user']
          : null,
      limit_usage_to_x_items: map['limit_usage_to_x_items'] != null
          ? map['limit_usage_to_x_items']
          : null,
      usage_limit: map['usage_limit'] != null ? map['usage_limit'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Coupon.fromJson(String source) => Coupon.fromMap(json.decode(source));
}
