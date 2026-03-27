import 'package:equatable/equatable.dart';
import 'package:html/parser.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team.dart';
import 'package:soccer_sport/video/domain/entities/video.dart';
import 'package:wordpress_api/wordpress_api.dart';

class VideoDetails extends Equatable {
  final String? title;
  final String? competition;
  final String? thumbnail;
  final String? date;
  final List<Video>? videos;

  VideoDetails({
    this.competition,
    this.title,
    this.thumbnail,
    this.videos,
    this.date,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  factory VideoDetails.fromJson(Map<String, dynamic> json) {
    return VideoDetails(
      title: json['title'] != null ? json['title'] : null,
      competition: json['competition'] != null ? json['competition'] : null,
      thumbnail: json["thumbnail"] != null ? json["thumbnail"] : null,
      date: json['date'] != null ? json['date'] : null,
      videos: json['videos'] != null
          ? (json['videos'] as List).map((e) => Video.fromJson(e)).toList()
          : null,
      // season: json['season'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (competition != null) 'competition': competition,
      if (title != null) 'title': title,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (videos != null) 'videos': videos!.map((e) => e.toJson()).toList(),
      if (date != null) 'date': date,
    };
  }

  @override
  List<Object?> get props => [title, date, competition, videos, thumbnail];
}
