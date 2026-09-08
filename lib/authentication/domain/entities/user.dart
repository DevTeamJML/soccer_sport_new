import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final String password;

  User({
    required this.username,
    required this.password,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishusername, this.tags});

  @override
  List<Object?> get props => [
        username,
        password,
      ];
}
