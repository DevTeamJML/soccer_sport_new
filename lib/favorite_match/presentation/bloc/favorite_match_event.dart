part of 'favorite_match_bloc.dart';

abstract class FavoriteMatchEvent extends Equatable {
  const FavoriteMatchEvent();

  @override
  List<Object> get props => [];
}

class GetFavoriteMatchRequest extends FavoriteMatchEvent {}

class PersistFavoriteMatchRequest extends FavoriteMatchEvent {
  final FootballMatch match;
  PersistFavoriteMatchRequest({required this.match});

  @override
  List<Object> get props => [match];
}

class RemoveFavoriteMatchRequest extends FavoriteMatchEvent {
  final FootballMatch match;
  RemoveFavoriteMatchRequest({required this.match});

  @override
  List<Object> get props => [match];
}

class PersistUpdateFavoriteMatchRequest extends FavoriteMatchEvent {
  final List<FootballMatch> match;
  PersistUpdateFavoriteMatchRequest({required this.match});

  @override
  List<Object> get props => [match];
}
