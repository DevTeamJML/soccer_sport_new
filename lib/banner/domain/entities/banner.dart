import 'package:equatable/equatable.dart';
import 'package:html/parser.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';
import 'package:wordpress_api/wordpress_api.dart';

class BannerHtml extends Equatable {
  final String? url;
  final String? href;

  BannerHtml({
    this.url,
    this.href,
  });

  // Article({@required this.url, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  factory BannerHtml.fromJson(String key, href) {
    return BannerHtml(url: key, href: href);
  }

  // Map<String, List<href>> toJson() {
  //   return {url: href};
  // }

  @override
  List<Object?> get props => [url, href];
}
