part of 'favourite_bloc.dart';

abstract class FavouriteState extends Equatable {
  const FavouriteState();

  @override
  List<Object> get props => [];
}

class FavouriteInitial extends FavouriteState {}

class LoadingFavouriteTeam extends FavouriteState {}

class FavouriteTeamLoaded extends FavouriteState {
  final Map<String, List<Team>> teams;

  FavouriteTeamLoaded({required this.teams});

  @override
  List<Object> get props => [teams];
}

class LoadingTeamList extends FavouriteState {}

class TeamListLoaded extends FavouriteState {
  final Map<String, List<Team>> teams;

  TeamListLoaded({required this.teams});

  @override
  List<Object> get props => [teams];
}

class PersistingFavouriteTeam extends FavouriteState {}

class FavouriteTeamPersisted extends FavouriteState {
  final bool teams;

  FavouriteTeamPersisted({required this.teams});

  @override
  List<Object> get props => [teams];
}

class PersistingTeamList extends FavouriteState {}

class TeamListPersisted extends FavouriteState {
  final bool teams;

  TeamListPersisted({required this.teams});

  @override
  List<Object> get props => [teams];
}

class RemovingFavouriteTeam extends FavouriteState {}

class FavouriteTeamRemoved extends FavouriteState {
  final bool teams;

  FavouriteTeamRemoved({required this.teams});

  @override
  List<Object> get props => [teams];
}

class LoadingAllFavourites extends FavouriteState {}

class AllFavouritesLoaded extends FavouriteState {
  final bool teams;

  AllFavouritesLoaded({required this.teams});

  @override
  List<Object> get props => [teams];
}

class TeamError extends FavouriteState {
  final String message;

  TeamError({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadingFavouriteTeamV2 extends FavouriteState {}

class FavouriteTeamV2Loaded extends FavouriteState {
  final List<Team> teams;

  FavouriteTeamV2Loaded({required this.teams});

  @override
  List<Object> get props => [teams];
}

class PersistingFavouriteTeamV2 extends FavouriteState {}

class FavouriteTeamV2Persisted extends FavouriteState {
  final bool teams;

  FavouriteTeamV2Persisted({required this.teams});

  @override
  List<Object> get props => [teams];
}

class RemovingFavouriteTeamV2 extends FavouriteState {}

class FavouriteTeamV2Removed extends FavouriteState {
  final bool teams;

  FavouriteTeamV2Removed({required this.teams});

  @override
  List<Object> get props => [teams];
}
