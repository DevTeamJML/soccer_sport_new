import 'package:equatable/equatable.dart';

class League extends Equatable {
  final int id;
  final String name;
  final String? type;
  final String? logo;
  final String? country;
  final String? round;

  final int? seasons;
  League({
    required this.id,
    required this.name,
    this.type,
    this.logo,
    this.round,
    this.country,
    this.seasons,
    // required this.season,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        logo,
        round,
        country,
        seasons,
      ];
}
