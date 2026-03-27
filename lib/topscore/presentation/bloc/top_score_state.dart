part of 'top_score_bloc.dart';

abstract class TopScoreState extends Equatable {
  const TopScoreState();

  @override
  List<Object> get props => [];
}

class TopScoreInitial extends TopScoreState {}

class LoadTopScores extends TopScoreState {}

class TopScoresLoaded extends TopScoreState {
  final List<TopScore> topScore;

  TopScoresLoaded({required this.topScore});

  @override
  List<Object> get props => [topScore];
}

class TopScoreError extends TopScoreState {
  final String message;

  TopScoreError({required this.message});

  @override
  List<Object> get props => [message];
}
