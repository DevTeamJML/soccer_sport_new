import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/util/failure_message.dart';
import 'package:soccer_sport/topscore/domain/entities/top_score.dart';
import 'package:soccer_sport/topscore/domain/usecases/get_top_score_by_league.dart';

part 'top_score_event.dart';
part 'top_score_state.dart';

class TopScoreBloc extends Bloc<TopScoreEvent, TopScoreState> {
  final GetTopScoreByLeague getTopScoreByLeague;

  TopScoreBloc({required GetTopScoreByLeague getTopScoreByLeague})
      : getTopScoreByLeague = getTopScoreByLeague,
        super(TopScoreInitial());

  @override
  Stream<TopScoreState> mapEventToState(
    TopScoreEvent event,
  ) async* {
    if (event is GetTopScoresByLeagueRequest) {
      yield LoadTopScores();
      final failureOrleagues = await getTopScoreByLeague(
          GetTopScoreByLeagueParams(id: event.id, season: event.season));
      yield failureOrleagues.fold(
        (failure) => TopScoreError(message: Failure2Message.map(failure)),
        (topScores) => TopScoresLoaded(topScore: topScores),
      );
    }

    //
  }
}
