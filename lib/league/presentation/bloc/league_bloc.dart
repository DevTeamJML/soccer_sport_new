import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/core/util/failure_message.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/domain/usecases/check_local_leagues.dart';
import 'package:soccer_sport/league/domain/usecases/get_all_league.dart';
import 'package:soccer_sport/league/domain/usecases/get_league_by_name.dart';
import 'package:soccer_sport/league/domain/usecases/get_local_leagues.dart';
import 'package:soccer_sport/league/domain/usecases/get_team_season.dart';
import 'package:soccer_sport/league/domain/usecases/get_update_date.dart';
import 'package:soccer_sport/league/domain/usecases/persist_local_leagues.dart';
import 'package:soccer_sport/league/domain/usecases/persist_update_date.dart';

part 'league_event.dart';
part 'league_state.dart';

class LeagueBloc extends Bloc<LeagueEvent, LeagueState> {
  final GetAllLeague getAllLeague;
  final GetLeagueByName getLeagueByName;
  final GetLocalLeagues getLocalLeagues;
  final PersistLocalLeagues persistLeagues;
  final CheckLocalLeagues checkLocalLeagues;
  final PersistUpdateDate persistUpdateDate;
  final GetUpdateDate getUpdateDate;
  final GetTeamSeason getTeamSeason;

  LeagueBloc({
    required GetAllLeague getAllLeague,
    required GetLeagueByName getLeagueByName,
    required GetLocalLeagues getLocalLeagues,
    required PersistLocalLeagues persistLeagues,
    required CheckLocalLeagues checkLocalLeagues,
    required PersistUpdateDate persistUpdateDate,
    required GetUpdateDate getUpdateDate,
    required GetTeamSeason getTeamSeason,
  })  : getAllLeague = getAllLeague,
        getLeagueByName = getLeagueByName,
        getLocalLeagues = getLocalLeagues,
        persistLeagues = persistLeagues,
        checkLocalLeagues = checkLocalLeagues,
        getUpdateDate = getUpdateDate,
        persistUpdateDate = persistUpdateDate,
        getTeamSeason = getTeamSeason,
        super(LeagueInitial());

  @override
  Stream<LeagueState> mapEventToState(
    LeagueEvent event,
  ) async* {
    if (event is GetAllLeagueRequest) {
      yield LoadLeagues();
      final failureOrleagues = await getAllLeague(NoParams());
      yield failureOrleagues.fold(
        (failure) => PersistLeaguesError(message: Failure2Message.map(failure)),
        (leagues) => LeaguesLoaded(leagues: leagues),
      );
    }

    if (event is GetLeagueByNameRequest) {
      yield LoadLeague();
      final failureOrleagues =
          await getLeagueByName(GetLeagueByNameParams(name: event.name));
      yield failureOrleagues.fold(
        (failure) => LeaguesError(message: Failure2Message.map(failure)),
        (leagues) => LeagueLoaded(leagues: leagues),
      );
    }

    if (event is GetLocalLeaguesRequest) {
      yield LoadPersistedLeagues();
      final failureOrleagues = await getLocalLeagues(NoParams());
      yield failureOrleagues.fold(
        (failure) => LeaguesError(message: Failure2Message.map(failure)),
        (leagues) => PersistedLeaguesLoaded(leagues: leagues),
      );
    }

    if (event is CheckLocalLeaguesRequest) {
      yield CheckLeagues();
      final failureOrleagues = await checkLocalLeagues(
          CheckLocalLeaguesParams(leagues: event.leagues));
      yield failureOrleagues.fold(
        (failure) => LeaguesError(message: Failure2Message.map(failure)),
        (success) => LeaguesMatched(success: success),
      );
    }

    if (event is PersistLocalLeaguesRequest) {
      yield PersistLeagues();

      final failureOrleagues = await persistLeagues(
          PersistLocalLeaguesParams(leagues: event.leagues));
      yield failureOrleagues.fold(
        (failure) => LeaguesError(message: Failure2Message.map(failure)),
        (success) => PersistLeaguesSuccess(success: success),
      );
    }

    if (event is PersistUpdateDateRequest) {
      yield PersistUpdateDateLoading();
      final failureOrleagues =
          await persistUpdateDate(PersistUpdateDateParams(date: event.date));
      yield failureOrleagues.fold(
        (failure) => LeaguesError(message: Failure2Message.map(failure)),
        (success) => PersistUpdateDateSuccess(success: success),
      );
    }

    if (event is GetUpdateDateRequest) {
      yield LoadUpdateDate();
      final failureOrleagues = await getUpdateDate(NoParams());
      yield failureOrleagues.fold(
        (failure) => PersistLeaguesError(message: Failure2Message.map(failure)),
        (success) => UpdatedDateLoaded(date: success),
      );
    }

    if (event is ChangeSeasonRequest) {
      yield SeasonLoaded();
    }

    if (event is GetTeamSeasonRequest) {
      yield LoadTeamSeason();
      final failureOrleagues =
          await getTeamSeason(GetTeamSeasonParams(id: event.id));
      yield failureOrleagues.fold(
        (failure) => LeaguesError(message: Failure2Message.map(failure)),
        (success) => TeamSeasonLoaded(success: success),
      );
    }
  }
}
