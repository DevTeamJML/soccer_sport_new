import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/customer/domain/entities/billing.dart';
import 'package:soccer_sport/customer/domain/entities/shipping.dart';

class Customer extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final Billing? billing;
  final Shipping? shipping;
  final String diamonds;
  final String coins;
  // final String points;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.billing,
    this.shipping,
    required this.diamonds,
    required this.coins,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.Customer, @required this.publishid, this.tags});

  @override
  List<Object?> get props =>
      [id, firstName, lastName, billing, shipping, diamonds];

  Map<String, dynamic> toMap() {
    return {
      'user_id': id,
      'first_name': firstName,
      'last_name': lastName,
      if (billing != null) 'billing': billing!.toMap(),
      if (shipping != null) 'shipping': shipping!.toMap(),
      'meta_data': [
        {'value': diamonds}
      ]
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    List<dynamic>? metaData = map['meta_data'] ?? null;
    Map<String, dynamic>? mycred = metaData != null
        ? metaData
            .firstWhereOrNull((element) => element['key'] == 'mycred_default')
        : null;
    Map<String, dynamic>? coin = metaData != null
        ? metaData
            .firstWhereOrNull((element) => element['key'] == 'mycred_coin')
        : null;
    return Customer(
      id: map['id'] ?? 0,
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      billing: map['billing'] != null ? Billing.fromMap(map['billing']) : null,
      shipping:
          map['shipping'] != null ? Shipping.fromMap(map['shipping']) : null,
      diamonds: mycred != null ? mycred['value'] ?? '0' : '0',
      coins: coin != null ? coin['value'] ?? '0' : '0',
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source));
}
