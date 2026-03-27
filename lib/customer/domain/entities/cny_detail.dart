import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/customer/domain/entities/billing.dart';
import 'package:soccer_sport/customer/domain/entities/shipping.dart';

class CnyRewardDetail extends Equatable {
  final int id;
  final int lastCheckIn;
  final int cnyLastCoin;
  final int totalCoin;

  CnyRewardDetail({
    required this.id,
    required this.lastCheckIn,
    required this.cnyLastCoin,
    required this.totalCoin,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.CnyRewardDetail, @required this.publishid, this.tags});

  @override
  List<Object?> get props => [id, lastCheckIn, cnyLastCoin, totalCoin];

  factory CnyRewardDetail.fromMap(Map<String, dynamic> map) {
    return CnyRewardDetail(
        id: map['ID'] ?? 0,
        cnyLastCoin:
            map['cny_last_coin'] != null ? int.parse(map['cny_last_coin']) : 0,
        lastCheckIn:
            map['cny_last_sign_in'] != null && map['cny_last_sign_in'] != ''
                ? int.parse(map['cny_last_sign_in'])
                : 0,
        totalCoin: map['cny_total_coin'] != null && map['cny_total_coin'] != ''
            ? int.parse(map['cny_total_coin'])
            : 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'cny_last_coin': cnyLastCoin,
      'cny_last_sign_in': lastCheckIn,
      'cny_total_coin': totalCoin,
    };
  }

  factory CnyRewardDetail.fromJson(String source) =>
      CnyRewardDetail.fromMap(json.decode(source));
}
