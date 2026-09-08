import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:html/parser.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team.dart';
import 'package:wordpress_api/wordpress_api.dart';

class News extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final String? image;
  final String? date;
  final List<String>? categories;

  News({
    this.id,
    this.title,
    this.description,
    this.image,
    this.date,
    this.categories,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        id: json['id'],
        title: json['title'] != null
            ? parse(json['title']).documentElement!.text
            : null,
        description: json['content'] != null
            ? parse(json['content']).documentElement!.text
            : null,
        image: json["featured_image"]["large"] != null
            ? (json["featured_image"]["large"] is String
                ? json["featured_image"]["large"]
                : null)
            : null,
        date: json['date'] != null ? json['date'] : null,
        categories: json['category'] != null
            ? (json['category'] as List<dynamic>)
                .map((e) => e as String)
                .toList()
            : []
        // season: json['season'],
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': description,
      'featured_image': {'large': image},
      'date': date,
      'category': jsonEncode(categories)
    };
  }

  @override
  List<Object?> get props => [id, title, description, image, date, categories];
}
