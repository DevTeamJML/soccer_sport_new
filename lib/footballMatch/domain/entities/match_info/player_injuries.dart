import 'package:equatable/equatable.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class PlayerInjuries extends Equatable {
  int id;
  String name;
  String type;
  String reason;

  PlayerInjuries({
    required this.name,
    required this.id,
    required this.type,
    required this.reason,
  });

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [name, id, type, reason];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'type': type,
      'reason': reason,
    };
  }

  factory PlayerInjuries.fromMap(Map<String, dynamic> map) {
    return PlayerInjuries(
      name: map['name'] ?? '',
      id: map['id'],
      reason: map['reason'],
      type: map['type'],
    );
  }
}
