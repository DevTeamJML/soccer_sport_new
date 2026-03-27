part of 'favourite_bloc.dart';

abstract class FavouriteEvent extends Equatable {
  const FavouriteEvent();

  @override
  List<Object> get props => [];
}

class GetFavouriteTeamRequest extends FavouriteEvent {}

class GetTeamListRequest extends FavouriteEvent {}

class GetAllFavouritesRequest extends FavouriteEvent {}

class PersistTeamListRequest extends FavouriteEvent {
  final Map<String, List<dynamic>> teams;

  PersistTeamListRequest({
    required this.teams,
  });

  @override
  List<Object> get props => [teams];
}

class PersistFavouriteTeamRequest extends FavouriteEvent {
  final Team teams;
  final String id;

  PersistFavouriteTeamRequest({
    required this.teams,
    required this.id,
  });

  @override
  List<Object> get props => [teams, id];
}

class RemoveFavouriteTeamRequest extends FavouriteEvent {
  final Team teams;
  final String id;

  RemoveFavouriteTeamRequest({
    required this.teams,
    required this.id,
  });

  @override
  List<Object> get props => [teams, id];
}

class GetFavouriteTeamRequestV2 extends FavouriteEvent {}

class PersistFavouriteTeamRequestV2 extends FavouriteEvent {
  final Team teams;

  PersistFavouriteTeamRequestV2({
    required this.teams,
  });

  @override
  List<Object> get props => [teams];
}

class RemoveFavouriteTeamRequestV2 extends FavouriteEvent {
  final Team teams;

  RemoveFavouriteTeamRequestV2({
    required this.teams,
  });

  @override
  List<Object> get props => [teams];
}
