import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/util/failure_message.dart';
import 'package:soccer_sport/standings/data/model/league_standings_model.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/usecases/get_standing_by_league.dart';

import '../../domain/usecases/get_standing_by_team.dart';

part 'standing_event.dart';
part 'standing_state.dart';

class StandingBloc extends Bloc<StandingEvent, StandingState> {
  final GetStandingByLeague getStandingByLeague;
  final GetStandingByTeam getStandingByTeam;

  StandingBloc(
      {required GetStandingByLeague getStandingByLeague,
      required GetStandingByTeam getStandingByTeam})
      : getStandingByLeague = getStandingByLeague,
        getStandingByTeam = getStandingByTeam,
        super(StandingInitial());

  @override
  Stream<StandingState> mapEventToState(
    StandingEvent event,
  ) async* {
    if (event is GetStandingsByLeagueRequest) {
      yield LoadStandings();
      final failureOrleagues = await getStandingByLeague(
          GetStandingByLeagueParams(id: event.id, season: event.season));
      yield failureOrleagues.fold(
        (failure) => StandingsError(message: Failure2Message.map(failure)),
        (leagues) => StandingsLoaded(standings: leagues),
      );
    }

    if (event is GetStandingByTeamRequest) {
      yield LoadStandingByTeam();
      final failureOrleagues = await getStandingByTeam(
          GetStandingByTeamParams(id: event.id, season: event.season));
      yield failureOrleagues.fold(
        (failure) => StandingsError(message: Failure2Message.map(failure)),
        (leagues) => StandingByTeamLoaded(standings: leagues),
      );
    }

    //
  }
}
