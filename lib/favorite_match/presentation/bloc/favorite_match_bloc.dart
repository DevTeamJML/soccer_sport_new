import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/core/util/failure_message.dart';
import 'package:soccer_sport/favorite_match/domain/usecases/get_favorite_matches.dart';
import 'package:soccer_sport/favorite_match/domain/usecases/persist_favorite_match.dart';
import 'package:soccer_sport/favorite_match/domain/usecases/remove_favorite_match.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';

import '../../domain/usecases/persist_update_favourite_match.dart';

part 'favorite_match_event.dart';
part 'favorite_match_state.dart';

class FavoriteMatchBloc extends Bloc<FavoriteMatchEvent, FavoriteMatchState> {
  final GetFavoriteMatches getFavoriteMatch;
  final PersistFavoriteMatch persistFavoriteMatch;
  final RemoveFavoriteMatch removeFavoriteMatch;
  final PersistUpdateFavoriteMatch persistUpdateFavoriteMatch;

  FavoriteMatchBloc({
    required GetFavoriteMatches getFavoriteMatch,
    required RemoveFavoriteMatch removeFavoriteMatch,
    required PersistFavoriteMatch persistFavoriteMatch,
    required PersistUpdateFavoriteMatch persistUpdateFavoriteMatch,
  })  : getFavoriteMatch = getFavoriteMatch,
        persistFavoriteMatch = persistFavoriteMatch,
        removeFavoriteMatch = removeFavoriteMatch,
        persistUpdateFavoriteMatch = persistUpdateFavoriteMatch,
        super(FootballMatchInitial());

  @override
  Stream<FavoriteMatchState> mapEventToState(
    FavoriteMatchEvent event,
  ) async* {
    if (event is GetFavoriteMatchRequest) {
      yield LoadFavoriteMatch();
      final failureOrFootballMatches = await getFavoriteMatch(NoParams());
      yield failureOrFootballMatches.fold(
        (failure) => FavoriteMatchError(message: Failure2Message.map(failure)),
        (matches) => FavoriteMatchLoaded(footballMatches: matches),
      );
    }

    if (event is RemoveFavoriteMatchRequest) {
      yield RemovingFavoriteMatch();
      final failureOrFootballMatches = await removeFavoriteMatch(
          RemoveFavoriteMatchParams(match: event.match));
      yield failureOrFootballMatches.fold(
        (failure) => FavoriteMatchError(message: Failure2Message.map(failure)),
        (matches) => FavoriteMatchRemoved(footballMatches: matches),
      );
    }

    if (event is PersistFavoriteMatchRequest) {
      yield PersistingFavoriteMatch();
      final failureOrFootballMatches = await persistFavoriteMatch(
          PersistFavoriteMatchParams(match: event.match));
      yield failureOrFootballMatches.fold(
        (failure) => FavoriteMatchError(message: Failure2Message.map(failure)),
        (matches) => FavoriteMatchPersisted(footballMatches: matches),
      );
    }

    if (event is PersistUpdateFavoriteMatchRequest) {
      yield PersistingUpdateFavoriteMatch();
      final failureOrFootballMatches = await persistUpdateFavoriteMatch(
          PersistUpdateFavoriteMatchParams(match: event.match));
      yield failureOrFootballMatches.fold(
        (failure) => FavoriteMatchError(message: Failure2Message.map(failure)),
        (matches) => UpdateFavoriteMatchPersisted(footballMatches: matches),
      );
    }
  }
}

// Stream<ArticleState> _eitherLoadedOrErrorState(
//   Either<Failure, List<Article>> failureOrArticles,
// ) async* {
//   yield failureOrArticles.fold(
//     (failure) => ArticleError(message: Failure2Message.map(failure)),
//     (articles) => ArticleLoaded(articles: articles),
//   );
// }


 