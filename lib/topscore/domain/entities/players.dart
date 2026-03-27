import 'dart:convert';

import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final int id;
  final int age;
  final String firstName;
  final String lastName;
  final String name;
  final String height;
  final String nationality;
  final String photo;
  final String weight;
  final bool injured;

  Player(
      {required this.id,
      required this.age,
      required this.firstName,
      required this.lastName,
      required this.name,
      required this.height,
      required this.nationality,
      required this.photo,
      required this.weight,
      required this.injured});
  @override
  List<Object?> get props => [
        id,
        age,
        firstName,
        lastName,
        name,
        height,
        nationality,
        photo,
        weight,
        injured,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'age': age,
      'firstname': firstName,
      'lastname': lastName,
      'name': name,
      'height': height,
      'nationality': nationality,
      'photo': photo,
      'weight': weight,
      'injured': injured,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id']?.toInt() ?? 0,
      age: map['age']?.toInt() ?? 0,
      firstName: map['firstname'] ?? '',
      lastName: map['lastname'] ?? '',
      name: map['name'] ?? '',
      height: map['height'] ?? '',
      nationality: map['nationality'] ?? '',
      photo: map['photo'] ?? '',
      weight: map['weight'] ?? '',
      injured: map['injured'] ?? false,
    );
  }
}
