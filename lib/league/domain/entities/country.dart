import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String name;
  final String? code;
  final String? flag;
  // final int seasons;
  Country({
    required this.name,
    this.code,
    this.flag,
    // required this.season,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  @override
  List<Object?> get props => [
        name,
        code,
        flag,
        // season,
      ];
}
