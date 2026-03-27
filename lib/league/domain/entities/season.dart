import 'package:equatable/equatable.dart';
import 'package:soccer_sport/league/domain/entities/coverage.dart';

class Season extends Equatable {
  final int year;
  final String? start;
  final String? end;
  final bool? current;
  final Coverage? coverage;
  // final int seasons;
  Season({
    required this.year,
    this.start,
    this.end,
    this.current,
    this.coverage,
    // required this.season,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  @override
  List<Object?> get props => [
        year,
        start,
        end,
        current,
        coverage,
        // season,
      ];
}
