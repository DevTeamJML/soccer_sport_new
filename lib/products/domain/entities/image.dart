import 'dart:convert';

import 'package:equatable/equatable.dart';

class Image extends Equatable {
  final String url;

  Image({
    required this.url,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishurl, this.tags});

  @override
  List<Object?> get props => [url];

  Map<String, dynamic> toMap() {
    return {
      'src': url,
    };
  }

  factory Image.fromMap(Map<String, dynamic> map) {
    return Image(
      url: map['src'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Image.fromJson(String source) => Image.fromMap(json.decode(source));
}
