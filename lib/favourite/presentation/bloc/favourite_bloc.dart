import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/core/util/failure_message.dart';
import 'package:soccer_sport/favourite/domain/entities/league_team.dart';
import 'package:soccer_sport/favourite/domain/usecase/get_all_favourites.dart';
import 'package:soccer_sport/favourite/domain/usecase/get_favourite_team.dart';
import 'package:soccer_sport/favourite/domain/usecase/get_team_list.dart';
import 'package:soccer_sport/favourite/domain/usecase/persist_favourite_team.dart';
import 'package:soccer_sport/favourite/domain/usecase/persist_team_list.dart';
import 'package:soccer_sport/favourite/domain/usecase/remove_favourite_team.dart';

import '../../../footballMatch/domain/entities/team.dart';
import '../../domain/usecase/get_favourite_team_v2.dart';
import '../../domain/usecase/persist_favourite_team_v2.dart';
import '../../domain/usecase/remove_favourite_team_v2.dart';

part 'favourite_event.dart';
part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final GetFavouriteTeam getFavouriteTeam;
  final GetTeamList getTeamList;
  final PersistFavouriteTeam persistFavouriteTeam;
  final PersistTeamList persistTeamList;
  final RemoveFavouriteTeam removeFavouriteTeam;
  final GetAllFavouriteTeam getAllFavouriteMatch;
  final GetFavouriteTeamV2 getFavouriteTeamV2;

  final PersistFavouriteTeamV2 persistFavouriteTeamV2;
  final RemoveFavouriteTeamV2 removeFavouriteTeamV2;

  FavouriteBloc({
    required GetFavouriteTeam getFavouriteTeam,
    required GetTeamList getTeamList,
    required PersistFavouriteTeam persistFavouriteTeam,
    required PersistTeamList persistTeamList,
    required RemoveFavouriteTeam removeFavouriteTeam,
    required GetAllFavouriteTeam getAllFavouriteMatch,
    required GetFavouriteTeamV2 getFavouriteTeamV2,
    required PersistFavouriteTeamV2 persistFavouriteTeamV2,
    required RemoveFavouriteTeamV2 removeFavouriteTeamV2,
  })  : getFavouriteTeam = getFavouriteTeam,
        getTeamList = getTeamList,
        persistFavouriteTeam = persistFavouriteTeam,
        persistTeamList = persistTeamList,
        removeFavouriteTeam = removeFavouriteTeam,
        getAllFavouriteMatch = getAllFavouriteMatch,
        getFavouriteTeamV2 = getFavouriteTeamV2,
        persistFavouriteTeamV2 = persistFavouriteTeamV2,
        removeFavouriteTeamV2 = removeFavouriteTeamV2,
        super(FavouriteInitial());

  @override
  Stream<FavouriteState> mapEventToState(
    FavouriteEvent event,
  ) async* {
    if (event is GetFavouriteTeamRequest) {
      yield LoadingFavouriteTeam();
      final failureOrTeams = await getFavouriteTeam(NoParams());
      yield failureOrTeams.fold(
        (failure) => TeamError(message: Failure2Message.map(failure)),
        (teams) => FavouriteTeamLoaded(teams: teams),
      );
    }

    if (event is GetTeamListRequest) {
      yield LoadingTeamList();
      final failureOrTeams = await getTeamList(NoParams());
      yield failureOrTeams.fold(
        (failure) => TeamError(message: Failure2Message.map(failure)),
        (teams) => TeamListLoaded(teams: teams),
      );
    }

    if (event is PersistFavouriteTeamRequest) {
      yield PersistingFavouriteTeam();
      final failureOrTeams = await persistFavouriteTeam(
          PersistFavouriteTeamParams(team: event.teams, id: event.id));
      yield failureOrTeams.fold(
        (failure) => TeamError(message: Failure2Message.map(failure)),
        (teams) => FavouriteTeamPersisted(teams: teams),
      );
    }

    if (event is PersistTeamListRequest) {
      yield PersistingTeamList();
      final failureOrTeams =
          await persistTeamList(PersistTeamListParams(team: event.teams));
      yield failureOrTeams.fold(
        (failure) => TeamError(message: Failure2Message.map(failure)),
        (teams) => TeamListPersisted(teams: teams),
      );
    }
    if (event is RemoveFavouriteTeamRequest) {
      yield RemovingFavouriteTeam();
      final failureOrTeams = await removeFavouriteTeam(
          RemoveFavouriteTeamParams(team: event.teams, id: event.id));
      yield failureOrTeams.fold(
        (failure) => TeamError(message: Failure2Message.map(failure)),
        (teams) => FavouriteTeamRemoved(teams: teams),
      );
    }

    if (event is GetAllFavouritesRequest) {
      yield LoadingAllFavourites();
      final failureOrTeams = await getAllFavouriteMatch(NoParams());
      yield failureOrTeams.fold(
        (failure) => TeamError(message: Failure2Message.map(failure)),
        (teams) => AllFavouritesLoaded(teams: teams),
      );
    }

    if (event is GetFavouriteTeamRequestV2) {
      yield LoadingFavouriteTeamV2();
      final failureOrTeams = await getFavouriteTeamV2(NoParams());
      yield failureOrTeams.fold(
        (failure) => TeamError(message: Failure2Message.map(failure)),
        (teams) => FavouriteTeamV2Loaded(teams: teams),
      );
    }
    if (event is PersistFavouriteTeamRequestV2) {
      yield PersistingFavouriteTeamV2();
      final failureOrTeams = await persistFavouriteTeamV2(
          PersistFavouriteTeamV2Params(team: event.teams));
      yield failureOrTeams.fold(
        (failure) => TeamError(message: Failure2Message.map(failure)),
        (teams) => FavouriteTeamV2Persisted(teams: teams),
      );
    }

    if (event is RemoveFavouriteTeamRequestV2) {
      yield RemovingFavouriteTeamV2();
      final failureOrTeams = await removeFavouriteTeamV2(
          RemoveFavouriteTeamV2Params(team: event.teams));
      yield failureOrTeams.fold(
        (failure) => TeamError(message: Failure2Message.map(failure)),
        (teams) => FavouriteTeamV2Removed(teams: teams),
      );
    }
  }
}
