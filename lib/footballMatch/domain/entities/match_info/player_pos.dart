import 'package:equatable/equatable.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class PlayerPos extends Equatable {
  int id;
  String name;
  int number;
  String? pos;
  String? grid;

  PlayerPos({
    required this.name,
    required this.id,
    this.grid,
    required this.number,
    this.pos,
  });

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [name, id, grid, number, pos];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'grid': grid,
      'number': number,
      'pos': pos,
    };
  }

  factory PlayerPos.fromMap(Map<String, dynamic> map) {
    return PlayerPos(
      name: map['name'] ?? '',
      id: map['id'] != null ? map['id'] : 0,
      pos: map['pos'] != null ? map['pos'] : null,
      number: map['number'],
      grid: map['grid'] != null ? map['grid'] : null,
    );
  }
}
