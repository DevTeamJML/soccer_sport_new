import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/customer/domain/entities/billing.dart';
import 'package:soccer_sport/customer/domain/entities/shipping.dart';

class VerifiedDetail extends Equatable {
  final bool verified;
  final bool p6_registered;

  VerifiedDetail({
    required this.verified,
    required this.p6_registered,
  });

  // Article({@required this.verified, @required this.title, @required this.description, this.VerifiedDetail, @required this.publishverified, this.tags});

  @override
  List<Object?> get props => [verified, p6_registered];

  factory VerifiedDetail.fromMap(Map<String, dynamic> map) {
    return VerifiedDetail(
      verified: map['verified'] ?? false,
      p6_registered:
          map['p6_registered'] != null ? map['p6_registered'] : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'verified': verified,
      'p6_registered': p6_registered,
    };
  }

  factory VerifiedDetail.fromJson(String source) =>
      VerifiedDetail.fromMap(json.decode(source));
}
