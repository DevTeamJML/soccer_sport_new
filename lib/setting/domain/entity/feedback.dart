import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';

class FeedbackC extends Equatable {
  final String email;
  final String comments;
  final File? attachment;
  FeedbackC({
    required this.email,
    required this.comments,
    this.attachment,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.FeedbackC, @required this.publishuserId, this.tags});

  @override
  List<Object?> get props => [email, attachment, comments];

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'comments': comments,
      if (attachment != null) 'attachment': attachment!.path,
    };
  }

  factory FeedbackC.fromMap(Map<String, dynamic> map) {
    return FeedbackC(
        email: map['email'] ?? '',
        comments: map['comments'] ?? '',
        attachment: map['attachment'] != null ? map['attachment'] : null);
  }

  String toJson() => json.encode(toMap());

  factory FeedbackC.fromJson(String source) =>
      FeedbackC.fromMap(json.decode(source));
}
