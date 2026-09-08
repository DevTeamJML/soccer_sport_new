part of 'top_score_bloc.dart';

abstract class TopScoreEvent extends Equatable {
  const TopScoreEvent();

  @override
  List<Object> get props => [];
}

class GetTopScoresByLeagueRequest extends TopScoreEvent {
  final String id;
  final String season;
  GetTopScoresByLeagueRequest({required this.id, required this.season});

  @override
  List<Object> get props => [id, season];
}
