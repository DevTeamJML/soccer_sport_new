import 'package:equatable/equatable.dart';

class Fixtures extends Equatable {
  final bool? event;
  final bool? lineups;
  final bool? statisticsFixtures;
  final bool? statisticsPlayers;

  // final int seasons;
  Fixtures({
    this.event,
    this.lineups,
    this.statisticsFixtures,
    this.statisticsPlayers,
    // required this.season,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  @override
  List<Object?> get props => [
        event,
        lineups,
        statisticsFixtures,
        statisticsPlayers,
        // season,
      ];
}
