import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:soccer_sport/products/domain/entities/image.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String description;
  final int parent;
  final Image? image;
  final String url;

  Category({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.parent,
    required this.url,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishname, this.tags});

  @override
  List<Object?> get props => [id, name, description, parent, image, url];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'parent': parent,
      '_links': {
        'self': [
          {'href': url}
        ]
      }
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    final list = map['_links']['self'] as List<dynamic>;
    return Category(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        image: map['image'] != null ? Image.fromMap(map['image']) : null,
        parent: map['parent'] ?? '',
        url: list.first['href']);
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));
}
