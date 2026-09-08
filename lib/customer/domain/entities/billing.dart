import 'dart:convert';

import 'package:equatable/equatable.dart';

class Billing extends Equatable {
  final String firstName;
  final String lastName;
  final String? company;
  final String address1;
  final String address2;
  final String city;
  final String postcode;
  final String? country;
  final String state;
  final String? email;
  final String phone;

  Billing({
    required this.firstName,
    required this.lastName,
    this.company,
    required this.address1,
    required this.address2,
    required this.city,
    required this.postcode,
    this.country,
    required this.state,
    this.email,
    required this.phone,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.Billing, @required this.publishid, this.tags});

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        company,
        address1,
        address2,
        city,
        postcode,
        country,
        state,
        email,
        phone
      ];

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      if (company != null) 'company': company,
      'address_1': address1,
      'address_2': address2,
      'city': city,
      'postcode': postcode,
      if (country != null) 'country': country,
      'state': state,
      if (email != null) 'email': email,
      'phone': phone,
    };
  }

  factory Billing.fromMap(Map<String, dynamic> map) {
    return Billing(
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      company: map['company'] ?? null,
      address1: map['address_1'] ?? '',
      address2: map['address_2'] ?? '',
      city: map['city'] ?? '',
      postcode: map['postcode'] ?? '',
      country: map['country'] ?? null,
      state: map['state'] ?? '',
      email: map['email'] ?? null,
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Billing.fromJson(String source) =>
      Billing.fromMap(json.decode(source));
}
