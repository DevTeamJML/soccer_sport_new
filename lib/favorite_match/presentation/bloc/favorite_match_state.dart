part of 'favorite_match_bloc.dart';

abstract class FavoriteMatchState extends Equatable {
  const FavoriteMatchState();

  @override
  List<Object?> get props => [];
}

class FootballMatchInitial extends FavoriteMatchState {}

class LoadFavoriteMatch extends FavoriteMatchState {}

class FavoriteMatchLoaded extends FavoriteMatchState {
  final List<FootballMatch> footballMatches;

  FavoriteMatchLoaded({required this.footballMatches});

  @override
  List<Object> get props => [footballMatches];
}

class RemovingFavoriteMatch extends FavoriteMatchState {}

class FavoriteMatchRemoved extends FavoriteMatchState {
  final bool footballMatches;

  FavoriteMatchRemoved({required this.footballMatches});

  @override
  List<Object> get props => [footballMatches];
}

class PersistingFavoriteMatch extends FavoriteMatchState {}

class FavoriteMatchPersisted extends FavoriteMatchState {
  final bool footballMatches;

  FavoriteMatchPersisted({required this.footballMatches});

  @override
  List<Object> get props => [footballMatches];
}

class FavoriteMatchError extends FavoriteMatchState {
  final String message;

  FavoriteMatchError({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadUpdateFavoriteMatch extends FavoriteMatchState {}

class UpdateFavoriteMatchLoaded extends FavoriteMatchState {
  final List<FootballMatch> footballMatches;

  UpdateFavoriteMatchLoaded({required this.footballMatches});

  @override
  List<Object> get props => [footballMatches];
}

class PersistingUpdateFavoriteMatch extends FavoriteMatchState {}

class UpdateFavoriteMatchPersisted extends FavoriteMatchState {
  final bool footballMatches;

  UpdateFavoriteMatchPersisted({required this.footballMatches});

  @override
  List<Object> get props => [footballMatches];
}
