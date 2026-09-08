import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/core/util/failure_message.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/entities/news_content.dart';
import 'package:soccer_sport/news/domain/usecases/get_news.dart';
import 'package:soccer_sport/news/domain/usecases/load_news.dart';
import 'package:soccer_sport/news/domain/usecases/refresh_news.dart';

import '../../domain/usecases/get_new_by_slug.dart';
import '../../domain/usecases/get_new_content.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNews getNews;
  final LoadNews loadNews;
  final RefreshNews refreshNews;
  final GetNewContent getNewContent;
  final GetNewsBySlug getNewsBySlug;
  NewsBloc({
    required GetNews getNews,
    required RefreshNews refreshNews,
    required LoadNews loadNews,
    required GetNewContent getNewContent,
    required GetNewsBySlug getNewsBySlug,
  })  : getNews = getNews,
        refreshNews = refreshNews,
        loadNews = loadNews,
        getNewContent = getNewContent,
        getNewsBySlug = getNewsBySlug,
        super(NewsInitial());

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is GetNewsRequest) {
      yield LoadAllNews();
      final failureOrFootballMatches =
          await getNews(GetNewsParams(page: event.page));
      yield failureOrFootballMatches.fold(
        (failure) => NewsError(message: Failure2Message.map(failure)),
        (news) => NewsLoaded(news: news),
      );
    }

    if (event is LoadNewsRequest) {
      yield LoadPaginationNews();
      final failureOrFootballMatches =
          await loadNews(LoadNewsParams(page: event.page));
      yield failureOrFootballMatches.fold(
        (failure) => NewsError(message: Failure2Message.map(failure)),
        (news) => PaginationNewsLoaded(news: news),
      );
    }

    if (event is RefreshNewsRequest) {
      yield LoadRefreshNews();
      final failureOrFootballMatches = await refreshNews(NoParams());
      yield failureOrFootballMatches.fold(
        (failure) => NewsError(message: Failure2Message.map(failure)),
        (news) => RefreshNewsLoaded(news: news),
      );
    }
    if (event is GetNewContentRequest) {
      yield LoadNewContent();
      final failureOrFootballMatches = await getNewContent(
          GetNewContentParams(id: event.id, userid: event.userid));
      yield failureOrFootballMatches.fold(
        (failure) => NewsError(message: Failure2Message.map(failure)),
        (news) => NewContentLoaded(id: news),
      );
    }
    if (event is GetNewsBySlugRequest) {
      yield LoadingNewsBySlug();
      final failureOrFootballMatches =
          await getNewsBySlug(GetNewsBySlugParams(slug: event.slug));
      yield failureOrFootballMatches.fold(
        (failure) => NewsError(message: Failure2Message.map(failure)),
        (news) => NewsBySlugLoaded(news: news),
      );
    }
  }
}
