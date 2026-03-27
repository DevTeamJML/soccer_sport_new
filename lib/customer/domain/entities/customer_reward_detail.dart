import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/customer/domain/entities/billing.dart';
import 'package:soccer_sport/customer/domain/entities/shipping.dart';

class CustomerRewardDetail extends Equatable {
  final int id;
  final int lastCheckIn;
  final int checkInCount;
  final List<int> eventPeriod;
  final List<int> leagues;

  CustomerRewardDetail({
    required this.id,
    required this.lastCheckIn,
    required this.checkInCount,
    required this.eventPeriod,
    required this.leagues,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.CustomerRewardDetail, @required this.publishid, this.tags});

  @override
  List<Object?> get props => [id, lastCheckIn, checkInCount, leagues];

  factory CustomerRewardDetail.fromMap(Map<String, dynamic> map) {
    return CustomerRewardDetail(
      id: map['id'] ?? 0,
      checkInCount:
          map['check_in_count'] != null ? int.parse(map['check_in_count']) : 0,
      lastCheckIn: map['last_check_in'] != null && map['last_check_in'] != ''
          ? int.parse(map['last_check_in'])
          : 0,
      eventPeriod: map['event_period'] != null && map['event_period'] != ''
          ? json.decode(map['event_period']).cast<int>().toList()
          : [],
      leagues: map['personal'] != null && map['personal'] != ''
          ? json.decode(map['personal']).cast<int>().toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'check_in_count': checkInCount,
      'last_check_in': lastCheckIn.toString(),
      'event_period': json.encode(eventPeriod),
      'personal': json.encode(leagues)
    };
  }

  factory CustomerRewardDetail.fromJson(String source) =>
      CustomerRewardDetail.fromMap(json.decode(source));
}
