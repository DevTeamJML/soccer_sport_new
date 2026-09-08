import 'package:equatable/equatable.dart';

class Player extends Equatable {
  int? id;
  String? name;
  Player({required this.id, this.name});

  @override
  List<Object?> get props => [
        id,
        name,
      ];

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] != null ? json['id'] : null,
      name: json['name'] != null ? json['name'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
