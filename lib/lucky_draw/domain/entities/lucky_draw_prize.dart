import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/customer/domain/entities/billing.dart';
import 'package:soccer_sport/customer/domain/entities/shipping.dart';

class LuckyDrawPrize extends Equatable {
  final int index;
  final DateTime date;

  LuckyDrawPrize({
    required this.date,
    required this.index,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.LuckyDrawPrize, @required this.publishid, this.tags});

  @override
  List<Object?> get props => [date, index];

  factory LuckyDrawPrize.fromMap(Map<String, dynamic> map) {
    return LuckyDrawPrize(
        index: int.parse(map.keys.toList()[0]),
        date: DateTime.fromMillisecondsSinceEpoch(
          map.values.toList()[0] is int
              ? map.values.toList()[0]
              : int.parse(map.values.toList()[0]),
        ));
  }

  Map<String, dynamic> toMap() {
    return {index.toString(): date.millisecondsSinceEpoch};
  }

  factory LuckyDrawPrize.fromJson(String source) =>
      LuckyDrawPrize.fromMap(json.decode(source));
}
