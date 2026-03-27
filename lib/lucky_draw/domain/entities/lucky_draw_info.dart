import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/customer/domain/entities/billing.dart';
import 'package:soccer_sport/customer/domain/entities/shipping.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_prize.dart';

class LuckyDrawInfo extends Equatable {
  final int? id;
  final int count;
  // final List<int> prizes;
  final List<LuckyDrawPrize> prizes;
  final List<int>? draw_prizes;
  final int? draw;

  LuckyDrawInfo({
    this.id,
    required this.count,
    required this.prizes,
    this.draw_prizes,
    this.draw,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.LuckyDrawInfo, @required this.publishid, this.tags});

  @override
  List<Object?> get props => [id, count, prizes, draw_prizes, draw];

  factory LuckyDrawInfo.fromMap(Map<String, dynamic> map) {
    return LuckyDrawInfo(
        id: map['id'] != null ? map['id'] : null,
        prizes: map['lucky_draw'] != null
            ? ((map['lucky_draw'] is String
                    ? jsonDecode(map['lucky_draw'])
                    : map['lucky_draw']) as List<dynamic>)
                .map((e) => LuckyDrawPrize.fromMap(e as Map<String, dynamic>))
                .toList()

            // (map['lucky_draw'] as List<dynamic>).map((e) => e as int).toList()
            : [],
        count: map['draw_count'] != null ? int.parse(map['draw_count']) : 0,
        draw_prizes: map['prizes'] != null ? map['prizes'] : null,
        draw: map['count'] != null ? map['count'] : null);
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'ID': id.toString(),
      'lucky_draw': json.encode(prizes.map((e) => e.toMap()).toList()),
      'draw_count': count,
      if (draw_prizes != null) 'prizes': json.encode(draw_prizes),
      if (draw != null) 'count': draw
    };
  }

  factory LuckyDrawInfo.fromJson(String source) =>
      LuckyDrawInfo.fromMap(json.decode(source));
}
