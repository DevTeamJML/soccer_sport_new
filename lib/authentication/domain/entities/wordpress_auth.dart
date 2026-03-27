import 'dart:convert';

import 'package:equatable/equatable.dart';

class WordpressAuth extends Equatable {
  final int id;
  final String token;
  final String displayName;
  final String username;
  final String email;

  WordpressAuth({
    required this.id,
    required this.token,
    required this.displayName,
    required this.email,
    required this.username,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishtoken, this.tags});

  @override
  List<Object?> get props => [token, displayName, username, email, id];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'token': token,
      'user_display_name': displayName,
      'user_email': email,
      'user_nicename': username,
    };
  }

  factory WordpressAuth.fromMap(Map<String, dynamic> map) {
    return WordpressAuth(
      id: map['id'] ?? 0,
      token: map['token'] ?? '',
      displayName: map['user_display_name'] ?? '',
      email: map['user_email'] ?? '',
      username: map['user_nicename'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory WordpressAuth.fromJson(String source) =>
      WordpressAuth.fromMap(json.decode(source));
}
