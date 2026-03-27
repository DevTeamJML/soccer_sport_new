import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class Video extends Equatable {
  final String? title;
  final String? id;
  final String? embed;
  final String? ytLink;

  Video({
    this.id,
    this.title,
    this.embed,
    this.ytLink,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  factory Video.fromJson(Map<String, dynamic> json) {
    String embed = '';
    String ytLink = '';

    if (json['embed'] != null) {
      var document = parse(json['embed']);
      var imgList = document.querySelectorAll("iframe") as List<dom.Element>;
      ytLink = imgList[0].attributes['src']!;
      embed = imgList[0].outerHtml;
    }
    return Video(
      id: json['id'] != null ? json['id'] : null,
      title: json['title'] != null ? json['title'] : null,
      embed: embed,
      ytLink: ytLink,
      // season: json['season'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (embed != null) 'embed': embed,
    };
  }

  @override
  List<Object?> get props => [id, title, embed];
}
