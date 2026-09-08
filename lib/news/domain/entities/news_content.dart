import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:html/parser.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team.dart';
import 'package:wordpress_api/wordpress_api.dart';

class NewsContent extends Equatable {
  final List<String> content;
  final bool get_points;

  NewsContent({
    required this.content,
    required this.get_points,
  });

  // Article({@required this.id, @required this.content, @required this.get_points, this.image, @required this.publishDate, this.tags});

  factory NewsContent.fromJson(Map<String, dynamic> json) {
    return NewsContent(
      content: json['content'] != null ? json['content'] : '',
      get_points: json['get_points'] != null ? json['get_points'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'content': get_points,
    };
  }

  @override
  List<Object?> get props => [content, get_points];
}
