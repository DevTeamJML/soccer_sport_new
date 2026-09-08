import 'package:equatable/equatable.dart';
import 'package:soccer_sport/league/domain/entities/fixtures.dart';

class Coverage extends Equatable {
  final Fixtures? fixtures;
  final bool? standings;
  final bool? players;
  final bool? topScores;
  final bool? topAssits;
  final bool? topCards;
  final bool? injuries;
  final bool? predictions;
  final bool? odds;

  Coverage({
    this.fixtures,
    this.standings,
    this.players,
    this.topScores,
    this.topAssits,
    this.topCards,
    this.injuries,
    this.predictions,
    this.odds,

    // required this.season,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  @override
  List<Object?> get props => [
        fixtures,
        standings,
        players,
        topScores,
        topAssits,
        topCards,
        injuries,
        predictions,
        odds,
        // season,
      ];
}
