import 'package:equatable/equatable.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class StatsInfo extends Equatable {
  String type;
  int value;
  StatsInfo({required this.type, required this.value});

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [type, value];

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'value': value,
    };
  }

  factory StatsInfo.fromMap(Map<String, dynamic> map) {
    var value = 0;
    if (map['value'] != null) {
      if (map['value'] is int) {
        value = map['value'];
      }
      if (map['value'] is String) {
        if ((map['value'] as String).contains("%")) {
          var removePercent = (map['value'] as String).replaceAll("%", "");
          value = int.parse(removePercent);
        }
      }
    }
    return StatsInfo(
      type: map['type'] ?? '',
      value: value,
    );
  }
}
